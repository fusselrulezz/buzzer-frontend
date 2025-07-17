/// Represents a single claim in the authentication system.
class Claim {
  /// The type of the claim, e.g., "email", "role", etc.
  final String type;

  /// The value of the claim, e.g., "user@example.com", "admin", etc.
  final String value;

  /// Initializes a new [Claim] instance with the provided type and value.
  const Claim(this.type, this.value);
}
