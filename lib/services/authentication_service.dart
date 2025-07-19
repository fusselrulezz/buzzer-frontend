import "dart:async";

import "package:buzzer/model/auth/stored_identity.dart";
import "package:buzzer/services/secure_storage_service.dart";
import "package:buzzer_client/buzzer_client.dart";
import "package:chopper/chopper.dart";
import "package:logger/logger.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/model/auth/identity.dart";
import "package:buzzer/services/api_service.dart";

/// Service for managing authentication and identity.
class AuthenticationService {
  final Logger _logger = getLogger("AuthenticationService");

  final ApiService _apiService = locator<ApiService>();

  Identity? _identity;

  /// The current identity of the user, if available.
  Identity? get identity => _identity;

  /// Checks if the user has an identity (i.e., is authenticated).
  bool get hasIdentity => _identity != null;

  Authenticator _authenticator = _ApiAuthenticator(identity: null);

  /// The authenticator used for API requests.
  Authenticator get authenticator => _authenticator;

  Timer? _refreshTimer;

  /// Clears the current identity and resets the authenticator.
  Future<void> clearIdentity() async {
    _identity = null;
    _authenticator = _ApiAuthenticator(identity: null);

    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
      _refreshTimer = null;
    }

    await locator<SecureStorageService>().deleteIdentity();

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    _logger.i("Cleared identity and authenticator");
  }

  /// Authenticates the user with the provided identity.
  Future<void> authenticate(Identity identity) async {
    _identity = identity;
    _authenticator = _ApiAuthenticator(identity: identity);

    await locator<SecureStorageService>().storeIdentity(
      StoredIdentity.fromIdentity(identity),
    );

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    if (_refreshTimer != null) {
      _refreshTimer!.cancel();
    }

    _refreshTimer = Timer.periodic(
      const Duration(minutes: 1),
      _refreshIdentity,
    );

    _logger.i("Authenticated with identity");
    _logger.i("Token expires at: ${identity.claims.expiresAt}");
  }

  Future<void> _refreshIdentity(Timer timer) async {
    if (_identity == null) {
      _logger.w("No identity to refresh");
      return;
    }

    final playerId = _identity!.claims.playerId;

    if (playerId == null) {
      _logger.w("No player ID in identity claims, cannot refresh");
      return;
    }

    _logger.i("Refreshing identity...");

    final refreshResponse = await locator<ApiService>().client
        .apiAuthRefreshPost(
          body: RefreshTokenRequestDto(
            playerId: playerId,
            refreshToken: _identity!.refreshToken,
          ),
        );

    if (refreshResponse.isSuccessful) {
      final body = refreshResponse.body;

      if (body == null) {
        _logger.w("Refresh response body is null");
        return;
      }

      _identity = _identity!.copyWith(accessToken: body.token);

      _logger.i("Successfully refreshed identity");
    } else {
      _logger.w("Failed to refresh identity");
    }
  }
}

class _ApiAuthenticator extends Authenticator {
  final Identity? identity;

  _ApiAuthenticator({required this.identity});

  @override
  FutureOr<Request?> authenticate(
    Request request,
    Response response, [
    Request? originalRequest,
  ]) {
    if (identity == null) {
      return null; // Not authenticated
    }

    final token = identity!.accessToken;

    return applyHeader(request, "Authorization", "Bearer $token");
  }
}
