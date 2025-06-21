import 'dart:convert';

import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/model/system_config.dart';
import 'package:flutter/services.dart';

class SystemConfigService {
  final _logger = getLogger((SystemConfigService).toString());

  SystemConfig? _config;

  SystemConfig get config => _config!;

  SystemConfigService();

  Future<void> ensureInitialized() async {
    if (_config != null) {
      _logger.i("Already initialized.");
      return;
    }

    try {
      var data = await rootBundle.loadString("assets/config/system.json");
      var jsonResult = jsonDecode(data);
      _config = SystemConfig.fromJson(jsonResult);
    } catch (e, stack) {
      _logger.e("Failed to load system config.", e, stack);
      rethrow;
    }

    _logger.i("System config loaded. Base url: ${_config!.serviceUrl}");
  }
}
