import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/services/system_config_service.dart';
import 'package:buzzer_client/buzzer_client.dart';

class ApiService {
  final SystemConfigService _systemConfigService =
      locator<SystemConfigService>();

  Buzzer? _client;

  Buzzer get client {
    _client ??= _buildClient();
    return _client!;
  }

  Buzzer? _buildClient() {
    return Buzzer.create(
      baseUrl: _systemConfigService.config.serviceUri,
    );
  }
}
