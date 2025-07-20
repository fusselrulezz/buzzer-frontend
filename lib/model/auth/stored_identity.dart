import "package:json_annotation/json_annotation.dart";

import "identity.dart";

part "stored_identity.g.dart";

/// Stores the identity of the user, used for storing it in shared preferences.
/// This class is used to persist the refresh token and its expiration date,
/// so that the user can remain logged in without needing to re-authenticate
/// frequently.
@JsonSerializable()
class StoredIdentity {
  /// The access token used for authentication.
  final String accessToken;

  /// The expiration date of the access token.
  final DateTime? accessTokenExpiresAt;

  /// The refresh token used to obtain a new access token.
  final String refreshToken;

  /// The expiration date of the refresh token.
  final DateTime? refreshTokenExpiresAt;

  /// Creates a new [StoredIdentity] instance.
  StoredIdentity({
    required this.accessToken,
    required this.accessTokenExpiresAt,
    required this.refreshToken,
    required this.refreshTokenExpiresAt,
  });

  /// Constructs a [StoredIdentity] instance from a JSON map.
  factory StoredIdentity.fromJson(Map<String, dynamic> json) =>
      _$StoredIdentityFromJson(json);

  /// Tranforms this [RandomNames] instance into a JSON map.
  Map<String, dynamic> toJson() => _$StoredIdentityToJson(this);

  /// Converts this [StoredIdentity] to an [Identity].
  Identity toIdentity() {
    return Identity.create(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Converts a [StoredIdentity] to an [Identity].
  static StoredIdentity fromIdentity(Identity identity) {
    return StoredIdentity(
      accessToken: identity.accessToken,
      accessTokenExpiresAt: identity.claims.expiresAt,
      refreshToken: identity.refreshToken,
      refreshTokenExpiresAt: DateTime.now().toUtc().add(
        Duration(days: 1), // Assuming refresh token is valid for 1 day
      ),
    );
  }
}
