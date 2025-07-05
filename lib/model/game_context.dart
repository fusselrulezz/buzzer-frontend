import "package:buzzer_client/buzzer_client.dart";

/// Holds the context of a game, such as the room ID.
/// As this class is immutable, it only stores data that does not
/// change during the game session.
class GameContext {
  /// The unique identifier for the game room.
  final String roomId;

  /// The name of the game room.
  final String roomName;

  /// The unique identifier for the user in the game room.
  final String userId;

  /// The name of the user in the game room.
  final String userName;

  /// The code used to join the game room.
  final String joinCode;

  /// Indicates whether the user is the host of the game room.
  final bool isHost;

  /// The initial game state, if available.
  final InitialGameState? initialGameState;

  /// Initializes a new [GameContext] instance.
  GameContext({
    required this.roomId,
    required this.roomName,
    required this.userId,
    required this.userName,
    required this.joinCode,
    required this.isHost,
    this.initialGameState,
  });
}

/// Represents the initial state of a game, including the buzzer state and players.
/// This is primarily used to initialize the game context when joining a game room.
class InitialGameState {
  /// The state of the buzzer.
  final BuzzerStateDto buzzerState;

  /// The list of players in the game room.
  final List<PlayerDto> players;

  /// Creates a new [InitialGameState] instance.
  InitialGameState({required this.buzzerState, required this.players});

  /// Creates an [InitialGameState] from the details of a game room.
  static InitialGameState fromDetails(PrivateGameRoomDto roomDetails) {
    return InitialGameState(
      buzzerState: roomDetails.buzzerState,
      players: roomDetails.players,
    );
  }
}
