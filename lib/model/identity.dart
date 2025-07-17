/// Stores the identity of the user, including access and refresh tokens.
class Identity {
  /// The access token used for authentication.
  final String accessToken;

  /// The refresh token used to obtain a new access token.
  final String refreshToken;

  /// Initializes a new [SmartIdentity] instance with the provided access and refresh tokens.
  Identity._({required this.accessToken, required this.refreshToken});

  /// Creates a new [Identity] instance from the provided access and refresh tokens.
  static Identity create({
    required String accessToken,
    required String refreshToken,
  }) {
    return Identity._(accessToken: accessToken, refreshToken: refreshToken);
  }
}
