import 'package:buzzer/services/authentication_service.dart';
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

  String get serviceUrl => _systemConfigService.serviceUrl;

  Uri get serviceUri => Uri.parse(serviceUrl);

  void invalidateClient() {
    _logger.i("Invalidating API client");

    _client?.client.dispose();
    _client = null;
  }

  Buzzer? _buildClient() {
    return Buzzer.create(
      baseUrl: serviceUri,
      authenticator: locator<AuthenticationService>().authenticator,
    );
  }
}
