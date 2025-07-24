import "package:auto_route/auto_route.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/services/game_context_service.dart";
import "package:collection/collection.dart";
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

  late GameContext _gameContext;

  /// The context of the game, containing information about the room,
  /// the user, and the initial game state.
  GameContext get gameContext => _gameContext;

  final BuzzerService _buzzerService = locator<BuzzerService>();

  final List<PlayerDto> _players = [];

  /// The list of players currently in the game.
  List<PlayerDto> get players => [..._players];

  /// Creates a new [IngameScreenModel] instance.
  IngameScreenModel() {
    final context = locator<GameContextService>().currentContext;

    if (context == null) {
      // Just assume that this will never happen, as the game context should
      // always be set before navigating to the ingame screen.
      // If it is not set, we cannot initialize the model properly.
      _logger.e(
        "Game context is not set, cannot initialize IngameScreenModel.",
      );
      return;
    }

    _gameContext = context;

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

  /// Whether the reset button is visible.
  bool get resetButtonVisible {
    final settings = gameContext.initialGameState?.settings;

    if (settings == null) {
      return gameContext.isHost;
    }

    if (settings.multipleBuzzersAllowed) {
      return true;
    }

    return gameContext.isHost;
  }

  /// Whether the reset button is enabled.
  bool get resetButtonEnabled {
    final settings = gameContext.initialGameState?.settings;

    if (settings == null) {
      return gameContext.isHost;
    }

    if (settings.multipleBuzzersAllowed) {
      return !_buzzerEnabled;
    }

    return !_buzzerEnabled;
  }

  final Map<String, bool> _playerBuzzerStates = {};

  /// The state of the buzzer for each player. This maps whether the buzzer is
  /// enabled or disabled for each player. A value of `true` means the buzzer
  /// is enabled, and `false` means it is disabled.
  Map<String, bool> get playerBuzzerStates => {
    // Include the current user's buzzer state
    gameContext.userId: _buzzerEnabled,
    // Include the buzzer states of other players
    ..._playerBuzzerStates,
  };

  void _applyInitialState(InitialGameState? initialState) {
    _logger.i("Applying initial game state...");
    _logger.i("Players: ${initialState?.players.length ?? 0}");

    _players.addAll(initialState?.players ?? []);

    var state = initialState?.buzzerState.firstWhereOrNull(
      (state) => state.buzzedPlayerId == gameContext.userId,
    );

    _buzzerEnabled = state?.isBuzzerActive ?? true;
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
      context.router.replaceAll([HomeRoute()]);
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
    if (playerId == gameContext.userId) {
      // If the current user buzzed, disable the buzzer for them.
      _buzzerEnabled = false;
    }

    if (gameContext.initialGameState?.settings.multipleBuzzersAllowed ??
        false) {
      // If multiple buzzers are allowed, disable the buzzer for the player
      // who buzzed.
      _playerBuzzerStates[playerId] = false;
    } else {
      // If only one buzzer is allowed, disable the buzzer for all other players.
      _buzzerEnabled = false;

      for (var entry in _playerBuzzerStates.entries) {
        final playerId = entry.key;
        _playerBuzzerStates[playerId] = false;
      }
    }

    rebuildUi();

    _logger.i("Received buzz from player: $playerId");
  }

  void _onBuzzerCleared(String playerId) {
    _buzzerEnabled = true;
    _playerBuzzerStates[playerId] = true;
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
    _playerBuzzerStates.remove(player.id);

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
