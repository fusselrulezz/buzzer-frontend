/// Holds the context of a game, such as the room ID.
/// As this class is immutable, it only stores data that does not
/// change during the game session.
class GameContext {
  /// The unique identifier for the game room.
  final String roomId;

  /// The name of the game room.
  final String roomName;

  /// The name of the user in the game room.
  final String userName;

  /// The code used to join the game room.
  final String joinCode;

  /// Initializes a new [GameContext] instance.
  GameContext({
    required this.roomId,
    required this.roomName,
    required this.userName,
    required this.joinCode,
  });
}
