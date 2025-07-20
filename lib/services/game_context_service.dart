import "package:buzzer/model/game_context.dart";

/// Service for managing the game context.
class GameContextService {
  GameContext? _currentContext;

  /// Gets the current game context.
  GameContext? get currentContext => _currentContext;

  /// Whether a game context is currently set.
  bool get hasContext => _currentContext != null;

  /// Sets the current game context.
  void setContext(GameContext context) {
    _currentContext = context;
  }
}
