import "dart:async";

import "package:chopper/chopper.dart";
import "package:logger/logger.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/model/identity.dart";
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

  /// Clears the current identity and resets the authenticator.
  Future<void> clearIdentity() async {
    _identity = null;
    _authenticator = _ApiAuthenticator(identity: null);

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    _logger.i("Cleared identity and authenticator");
  }

  /// Authenticates the user with the provided identity.
  Future<void> authenticate(Identity identity) async {
    _identity = identity;
    _authenticator = _ApiAuthenticator(identity: identity);

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    _logger.i("Authenticated with identity");
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
