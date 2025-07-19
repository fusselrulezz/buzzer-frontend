import "dart:convert";

import "package:buzzer/model/auth/claims.dart";

/// Stores the identity of the user, including access and refresh tokens.
class Identity {
  /// The access token used for authentication.
  final String accessToken;

  /// The refresh token used to obtain a new access token.
  final String refreshToken;

  /// The claims associated with the identity.
  final Claims claims;

  /// Initializes a new [Identity] instance with the provided access and refresh tokens.
  Identity._({
    required this.accessToken,
    required this.refreshToken,
    required this.claims,
  });

  /// Creates a copy of the current [Identity] with optional new values for
  /// access token, refresh token, and claims.
  Identity copyWith({
    String? accessToken,
    String? refreshToken,
    Claims? claims,
  }) {
    return Identity._(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      claims: claims ?? this.claims,
    );
  }

  /// Creates a new [Identity] instance from the provided access and refresh tokens.
  static Identity create({
    required String accessToken,
    required String refreshToken,
  }) {
    final claimsMap = _parseJwt(accessToken) ?? {};

    return Identity._(
      accessToken: accessToken,
      refreshToken: refreshToken,
      claims: Claims(claimsMap),
    );
  }

  static Map<String, dynamic>? _parseJwt(String token) {
    final parts = token.split(".");

    if (parts.length != 3) {
      return null;
    }

    final payload = _decodeBase64(parts[1]);

    if (payload == null) {
      return null;
    }

    final payloadMap = json.decode(payload);

    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }

    return payloadMap;
  }

  static String? _decodeBase64(String str) {
    var output = str.replaceAll("-", "+").replaceAll("_", "/");

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += "==";
        break;
      case 3:
        output += "=";
        break;
      default:
        return null; // Invalid base64 string
    }

    return utf8.decode(base64Url.decode(output));
  }
}
