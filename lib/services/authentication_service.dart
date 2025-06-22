import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:logger/logger.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/model/identity.dart';
import 'package:buzzer/services/api_service.dart';

class AuthenticationService {
  final Logger _logger = getLogger("AuthenticationService");

  final ApiService _apiService = locator<ApiService>();

  Identity? _identity;

  bool get hasIdentity => _identity != null;

  Authenticator _authenticator = _ApiAuthenticator(identity: null);

  Authenticator get authenticator => _authenticator;

  void clearIdentity() {
    _identity = null;
    _authenticator = _ApiAuthenticator(identity: null);

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    _logger.i("Cleared identity and authenticator");
  }

  void authenticate(Identity identity) {
    _identity = identity;
    _authenticator = _ApiAuthenticator(
      identity: identity,
    );

    // Invalidate the API client to force a refresh of the authenticator
    _apiService.invalidateClient();

    _logger.i("Authenticated with identity");
  }
}

class _ApiAuthenticator extends Authenticator {
  final Identity? identity;

  _ApiAuthenticator({
    required this.identity,
  });

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
