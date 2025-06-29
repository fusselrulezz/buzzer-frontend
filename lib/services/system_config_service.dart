import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/model/system_config.dart';

class SystemConfigService {
  final _logger = getLogger("SystemConfigService");

  SystemConfig? _config;

  SystemConfig get config => _config!;

  String? _serviceUrl;

  /// The effective service URL to use for API calls.
  /// This resolves relative paths correctly for web applications.
  /// For example, if the service URL is `/api`, it will resolve to
  /// `https://yourdomain.com/api` on web.
  String get serviceUrl {
    if (_serviceUrl == null) {
      _serviceUrl = _resolveServiceUrl();
      _logger.i("Using service URL: $_serviceUrl");
    }

    return _serviceUrl!;
  }

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

  String _resolveServiceUrl() {
    final serviceUrl = _config!.serviceUrl;

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
