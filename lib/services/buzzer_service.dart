import 'dart:async';

import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer_client/buzzer_client.dart';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/services/system_config_service.dart';

class BuzzerService {
  final Logger _logger = getLogger("BuzzerService");

  final SystemConfigService _systemConfigService =
      locator<SystemConfigService>();

  String get hubUrl => "${_systemConfigService.config.serviceUrl}/buzzer";

  HubConnection? _hubConnection;

  // Streams

  final StreamController<String> _buzzedController =
      StreamController<String>.broadcast();

  Stream<String> get buzzedStream => _buzzedController.stream;

  final StreamController<String> _buzzerClearedController =
      StreamController<String>.broadcast();

  Stream<String> get buzzerClearedStream => _buzzerClearedController.stream;

  final StreamController<PlayerDto> _playerConnectedController =
      StreamController<PlayerDto>.broadcast();

  Stream<PlayerDto> get playerConnectedStream =>
      _playerConnectedController.stream;

  final StreamController<PlayerDto> _playerDisconnectedController =
      StreamController<PlayerDto>.broadcast();

  Stream<PlayerDto> get playerDisconnectedStream =>
      _playerDisconnectedController.stream;

  Future<void> connect() async {
    if (_hubConnection != null &&
        _hubConnection!.state == HubConnectionState.Connected) {
      _logger.i("Already connected to the hub.");

      await disconnect();

      _logger.i("Reconnecting to the hub...");
    }

    _logger.i("Connecting to hub at: $hubUrl");

    _hubConnection = HubConnectionBuilder()
        .withUrl(hubUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: _resolveAccessToken,
            ))
        .withAutomaticReconnect()
        .build();

    _initConnection(_hubConnection!);

    try {
      await _hubConnection!.start();
      _logger.i("Connected to the hub successfully.");
    } catch (e) {
      _logger.e("Failed to connect to the hub: $e");
      rethrow;
    }
  }

  Future<String> _resolveAccessToken() async {
    final service = locator<AuthenticationService>();

    final accessToken = service.identity?.accessToken;

    if (accessToken == null) {
      _logger.w("No identity found, cannot get access token.");
      return "";
    }

    return accessToken;
  }

  void _initConnection(HubConnection connection) {
    connection.onclose(_onConnectionClosed);

    connection.on("PlayerBuzzed", _onPlayerBuzzed);
    connection.on("BuzzerCleared", _onBuzzerCleared);

    connection.on("PlayerConnected", _onPlayerConnected);
    connection.on("PlayerDisconnected", _onPlayerDisconnected);
  }

  Future<void> _onConnectionClosed({Exception? error}) async {
    _logger.w("Connection closed: ${error?.toString() ?? 'No error'}");
  }

  Future<void> disconnect() async {
    if (_hubConnection == null) {
      _logger.w("No active hub connection to disconnect.");
      return;
    }

    try {
      await _hubConnection!.stop();
      _logger.i("Disconnected from the hub successfully.");
    } catch (e) {
      _logger.e("Error while disconnecting: $e");
    } finally {
      _hubConnection = null;
    }
  }

  Future<void> buzz(String roomId, String playerId) async {
    if (_hubConnection == null ||
        _hubConnection!.state != HubConnectionState.Connected) {
      _logger.w("Cannot buzz, not connected to the hub.");
      return;
    }

    try {
      await _hubConnection!.invoke("Buzz");
      _logger.i("Buzz sent for player $playerId in room $roomId.");
    } catch (e) {
      _logger.e("Failed to send buzz: $e");
      rethrow;
    }
  }

  Future<void> clearBuzzer(String roomId) async {
    if (_hubConnection == null ||
        _hubConnection!.state != HubConnectionState.Connected) {
      _logger.w("Cannot reset buzzer, not connected to the hub.");
      return;
    }

    try {
      await _hubConnection!.invoke("ClearBuzzer");
      _logger.i("Buzzer clear for room $roomId.");
    } catch (e) {
      _logger.e("Failed to reset buzzer: $e");
      rethrow;
    }
  }

  void _onPlayerBuzzed(List<Object?>? arguments) {
    final playerId = arguments?[0] as String?;

    if (playerId == null) {
      _logger.w("Received buzz event with null player ID.");
      return;
    }

    _logger.i("Player buzzed: $playerId");
    _buzzedController.add(playerId);
  }

  void _onBuzzerCleared(List<Object?>? arguments) {
    final playerId = arguments?[0] as String?;

    if (playerId == null) {
      _logger.w("Received buzzer cleared event with null player ID.");
      return;
    }

    _logger.i("Buzzer cleared by player: $playerId");
    _buzzerClearedController.add(playerId);
  }

  void _onPlayerConnected(List<Object?>? arguments) {
    try {
      if (arguments == null || arguments.isEmpty) {
        _logger
            .w("Received player connected event with null or empty arguments.");
        return;
      }

      final player = PlayerDto.fromJson(arguments[0] as Map<String, dynamic>);

      _logger.i("Player connected: ${player.id} with name: ${player.name}");

      _playerConnectedController.add(player);
    } catch (e) {
      _logger.e("Error processing player connected event: $e");
      return;
    }
  }

  void _onPlayerDisconnected(List<Object?>? arguments) {
    try {
      if (arguments == null || arguments.isEmpty) {
        _logger.w(
            "Received player disconnected event with null or empty arguments.");
        return;
      }

      final player = PlayerDto.fromJson(arguments[0] as Map<String, dynamic>);

      _logger.i("Player disconnected: ${player.id} with name: ${player.name}");

      _playerDisconnectedController.add(player);
    } catch (e) {
      _logger.e("Error processing player disconnected event: $e");
      return;
    }
  }
}
