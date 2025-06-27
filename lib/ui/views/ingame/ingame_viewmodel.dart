import 'dart:async';

import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer/services/buzzer_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/model/game_context.dart';

class IngameViewModel extends BaseViewModel {
  final GameContext gameContext;

  final BuzzerService _buzzerService = locator<BuzzerService>();

  final RouterService _routerService = locator<RouterService>();

  late final StreamSubscription<String> _buzzedSubscription;
  late final StreamSubscription<String> _playerConnectedSubscription;
  late final StreamSubscription<String> _playerDisconnectedSubscription;

  IngameViewModel({
    required this.gameContext,
  }) {
    _buzzedSubscription = _buzzerService.buzzedStream.listen(_onPlayerBuzzed);
    _playerConnectedSubscription =
        _buzzerService.playerConnectedStream.listen(_onPlayerConnected);
    _playerDisconnectedSubscription =
        _buzzerService.playerDisconnectedStream.listen(_onPlayerDisconnected);
  }

  String get roomName => gameContext.roomName;

  String get userName => gameContext.userName;

  String get joinCode => gameContext.joinCode;

  bool get isHost => gameContext.isHost;

  bool _buzzerEnabled = true;

  bool get buzzerEnabled => _buzzerEnabled;

  @override
  Future<void> dispose() async {
    await _buzzedSubscription.cancel();
    await _playerConnectedSubscription.cancel();
    await _playerDisconnectedSubscription.cancel();
    super.dispose();
  }

  Future<void> onPressedLeaveRoom() async {
    locator<AuthenticationService>().clearIdentity();
    _buzzerService.disconnect();
    _routerService.pop();
  }

  Future<void> onPressedBuzzer() async {
    if (!_buzzerEnabled) {
      return;
    }

    _buzzerEnabled = true;
    _buzzerService.buzz(gameContext.roomId, gameContext.userId);

    rebuildUi();
  }

  Future<void> _onPlayerBuzzed(String playerId) async {
    _buzzerEnabled = false;
    rebuildUi();
  }

  void _onPlayerConnected(String playerId) {}

  void _onPlayerDisconnected(String playerId) {}
}
