import 'dart:async';

import 'package:logger/logger.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer/services/system_config_service.dart';
import 'package:buzzer_client/buzzer_client.dart';

class BuzzerService {
  final Logger _logger = getLogger("BuzzerService");

  final SystemConfigService _systemConfigService =
      locator<SystemConfigService>();

  String get hubUrl {
    final serviceUrl = _systemConfigService.serviceUrl;

    // If the service URL ends with a slash, we append "buzzer" directly.
    // Otherwise, we append "/buzzer" to ensure the URL is correct.
    if (serviceUrl.endsWith("/")) {
      return "${serviceUrl}buzzer";
    }

    return "$serviceUrl/buzzer";
  }

  BuzzerSignalClient? _client;

  BuzzerSignalClient get client {
    if (_client == null) {
      _logger.w("Buzzer client is not initialized. Call connect() first.");
      throw StateError("Buzzer client is not initialized.");
    }

    return _client!;
  }

  Future<void> connect() async {
    if (_client == null) {
      _client = BuzzerSignalClient(
        url: hubUrl,
        accessTokenFactory: _resolveAccessToken,
        autoReconnect: true,
      );
      _logger.i("Set up client with url: $hubUrl");
    }

    await _client!.connect();
  }

  Future<String> _resolveAccessToken() async {
    final service = locator<AuthenticationService>();

    final accessToken = service.identity?.accessToken;

    if (accessToken == null) {
      _logger.w("No identity found, cannot get access token.");
      return "";
    }

    return accessToken;
  }

  Future<void> disconnect() async {
    if (_client == null) {
      _logger.w("No client to disconnect.");
      return;
    }

    try {
      await _client!.disconnect();
      _logger.i("Disconnected from buzzer hub.");
    } catch (e) {
      _logger.e("Error disconnecting from buzzer hub: $e");
    } finally {
      _client = null;
    }
  }
}
