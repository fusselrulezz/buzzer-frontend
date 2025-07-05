/// Stores the identity of the user, including access and refresh tokens.
class Identity {
  /// The access token used for authentication.
  final String accessToken;

  /// The refresh token used to obtain a new access token.
  final String refreshToken;

  /// Initializes a new [Identity] instance with the provided access and refresh tokens.
  Identity({required this.accessToken, required this.refreshToken});
}
