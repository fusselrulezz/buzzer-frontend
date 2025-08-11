import "dart:io";

import "package:flutter/foundation.dart";
import "package:logger/logger.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/system_config_service.dart";
import "package:buzzer_client/buzzer_client.dart";

/// Service for managing API interactions with the Buzzer backend.
class ApiService {
  final Logger _logger = getLogger("ApiService");

  final SystemConfigService _systemConfigService =
      locator<SystemConfigService>();

  Buzzer? _client;

  /// The API client used to make requests to the Buzzer backend.
  Buzzer get client {
    _client ??= _buildClient();
    return _client!;
  }

  /// The URL of the Buzzer service, constructed from the system configuration.
  String get serviceUrl => _systemConfigService.serviceUrl;

  /// The URI of the Buzzer service, constructed from the service URL.
  Uri get serviceUri => Uri.parse(serviceUrl);

  /// Invalidates the current API client, forcing a new client to be created
  /// on the next request. This is useful when the authentication token changes.
  void invalidateClient() {
    _logger.i("Invalidating API client");

    _client?.client.dispose();
    _client = null;
  }

  Buzzer? _buildClient() {
    if (kDebugMode) {
      // Ignore bad certificate errors in debug mode
      HttpOverrides.global = _IgnoreCertificateHttpOverride();
    }

    return Buzzer.create(
      baseUrl: serviceUri,
      authenticator: locator<AuthenticationService>().authenticator,
    );
  }
}

class _IgnoreCertificateHttpOverride extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (_, _, _) => true;
  }
}
