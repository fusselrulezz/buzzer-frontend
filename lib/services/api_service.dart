import 'package:buzzer/services/authentication_service.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/services/system_config_service.dart';
import 'package:buzzer_client/buzzer_client.dart';

class ApiService {
  final Logger _logger = getLogger("ApiService");

  final SystemConfigService _systemConfigService =
      locator<SystemConfigService>();

  Buzzer? _client;

  Buzzer get client {
    _client ??= _buildClient();
    return _client!;
  }

  String? _serviceUrl;

  String get serviceUrl {
    if (_serviceUrl == null) {
      _serviceUrl = _resolveServiceUrl();
      _logger.i("Using service URL: $_serviceUrl");
    }

    return _serviceUrl!;
  }

  Uri get serviceUri => Uri.parse(serviceUrl);

  void invalidateClient() {
    _logger.i("Invalidating API client");
    _client = null;
  }

  Buzzer? _buildClient() {
    return Buzzer.create(
      baseUrl: serviceUri,
      authenticator: locator<AuthenticationService>().authenticator,
    );
  }

  String _resolveServiceUrl() {
    final serviceUrl = _systemConfigService.config.serviceUrl;

    if (kIsWeb) {
      // For web, we allow service URLs based on the origin or relative paths.

      final uri = Uri.tryParse(serviceUrl);

      if (serviceUrl.startsWith('/')) {
        return Uri.base.origin + serviceUrl;
      } else if (uri != null && !uri.isAbsolute) {
        return Uri.base.resolve(serviceUrl).toString();
      }
    }

    return serviceUrl;
  }
}
