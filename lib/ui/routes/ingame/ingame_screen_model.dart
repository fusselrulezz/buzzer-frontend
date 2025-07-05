import "package:auto_route/auto_route.dart";
import "package:flutter/widgets.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/helper/managed_stream_subscriptions.dart";
import "package:buzzer/model/game_context.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer_client/buzzer_client.dart";

class IngameScreenModel extends BaseViewModel with ManagedStreamSubscriptions {
  final _logger = getLogger("IngameScreenModel");

  final GameContext gameContext;

  final BuzzerService _buzzerService = locator<BuzzerService>();

  final List<PlayerDto> _players = [];

  List<PlayerDto> get players => [..._players];

  IngameScreenModel({required this.gameContext}) {
    _logger.i(
      "IngameScreenModel initialized for room: ${gameContext.roomName}, user: ${gameContext.userName}",
    );

    _applyInitialState(gameContext.initialGameState);

    addSubscriptions([
      _buzzerService.client.buzzedStream.listen(_onPlayerBuzzed),
      _buzzerService.client.buzzerClearedStream.listen(_onBuzzerCleared),
      _buzzerService.client.playerConnectedStream.listen(_onPlayerConnected),
      _buzzerService.client.playerDisconnectedStream.listen(
        _onPlayerDisconnected,
      ),
    ]);
  }

  String get roomName => gameContext.roomName;

  String get userName => gameContext.userName;

  String get joinCode => gameContext.joinCode;

  bool get isHost => gameContext.isHost;

  bool _buzzerEnabled = true;

  bool get buzzerEnabled => _buzzerEnabled;

  bool get resetButtonEnabled => !_buzzerEnabled;

  void _applyInitialState(InitialGameState? initialState) {
    _logger.i("Applying initial game state...");
    _logger.i("Players: ${initialState?.players.length ?? 0}");

    _players.addAll(initialState?.players ?? []);
    _buzzerEnabled = initialState?.buzzerState.isBuzzerActive ?? true;
  }

  @override
  Future<void> dispose() async {
    await disposeSubscriptions();
    super.dispose();
  }

  Future<void> onPressedLeaveRoom(BuildContext context) async {
    locator<AuthenticationService>().clearIdentity();

    _buzzerService.disconnect();

    if (context.mounted) {
      context.router.popUntilRoot();
    }
  }

  Future<void> onPressedBuzzer() async {
    if (!_buzzerEnabled) {
      return;
    }

    await _buzzerService.client.buzz(gameContext.roomId, gameContext.userId);

    rebuildUi();
  }

  Future<void> _onPlayerBuzzed(String playerId) async {
    _buzzerEnabled = false;
    rebuildUi();

    _logger.i("Received buzz from player: $playerId");
  }

  void _onBuzzerCleared(String playerId) {
    _buzzerEnabled = true;
    rebuildUi();

    _logger.i("Buzzer cleared by player: $playerId");
  }

  void _onPlayerConnected(PlayerDto player) {
    // Check if the player is already in the list
    if (_players.any((p) => p.id == player.id)) {
      return;
    }

    // If not, add the player to the list
    _players.add(player);
    rebuildUi();

    _logger.i("Player connected: ${player.name} (${player.id})");
  }

  void _onPlayerDisconnected(PlayerDto player) {
    // Remove the player from the list if they are connected
    _players.removeWhere((p) => p.id == player.id);
    rebuildUi();

    _logger.i("Player disconnected: ${player.name} (${player.id})");
  }

  Future<void> onPressedResetBuzzer() async {
    if (!resetButtonEnabled) {
      return;
    }

    await _buzzerService.client.clearBuzzer(gameContext.roomId);
  }
}
