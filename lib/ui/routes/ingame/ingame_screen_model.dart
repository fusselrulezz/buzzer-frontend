import "package:auto_route/auto_route.dart";
import "package:buzzer/services/game_context_service.dart";
import "package:flutter/widgets.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/helper/managed_stream_subscriptions.dart";
import "package:buzzer/model/game_context.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer_client/buzzer_client.dart";

/// The view model for the ingame screen, managing the game state and player
/// interactions.
class IngameScreenModel extends BaseViewModel with ManagedStreamSubscriptions {
  final _logger = getLogger("IngameScreenModel");

  /// The context of the game, containing information about the room,
  /// the user, and the initial game state.
  GameContext get gameContext => locator<GameContextService>().currentContext!;

  final BuzzerService _buzzerService = locator<BuzzerService>();

  final List<PlayerDto> _players = [];

  /// The list of players currently in the game.
  List<PlayerDto> get players => [..._players];

  /// Creates a new [IngameScreenModel] instance.
  IngameScreenModel() {
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

  /// The name of the room the user is currently in.
  String get roomName => gameContext.roomName;

  /// The name of the player in the game.
  String get userName => gameContext.userName;

  /// The join code for the game room, used for joining the game.
  String get joinCode => gameContext.joinCode;

  /// Whether the current user is the host of the game.
  bool get isHost => gameContext.isHost;

  bool _buzzerEnabled = true;

  /// Whether the buzzer is currently enabled for the user.
  bool get buzzerEnabled => _buzzerEnabled;

  /// Whether the reset button is enabled.
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

  /// Will be called when the user presses the "Leave Room" button.
  Future<void> onPressedLeaveRoom(BuildContext context) async {
    await locator<AuthenticationService>().clearIdentity();

    _buzzerService.disconnect();

    if (context.mounted) {
      context.router.popUntilRoot();
    }
  }

  /// Will be called when the user presses the buzzer button.
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

  /// Will be called when the user presses the "Reset Buzzer" button.
  Future<void> onPressedResetBuzzer() async {
    if (!resetButtonEnabled) {
      return;
    }

    await _buzzerService.client.clearBuzzer(gameContext.roomId);
  }
}
