import "package:collection/collection.dart";

/// Represents a collection of claims, which are key-value pairs used for
/// authentication and authorization purposes.
class Claims extends DelegatingMap<String, dynamic> {
  /// Initializes a new [Claims] instance with the provided map of claims.
  Claims(super.base);

  /// Gets the unix timestamp when the token expires.
  /// Returns 0 if the "exp" claim is not present or is not a valid integer.
  int get expiresTimestamp => this["exp"] as int? ?? 0;

  /// Gets the expiration date of the token.
  DateTime get expiresAt {
    final timestamp = expiresTimestamp;
    return timestamp > 0
        ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true)
        : DateTime.now().toUtc();
  }

  /// Gets the player ID from the claims.
  String? get playerId =>
      this["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"]
          as String?;
}
