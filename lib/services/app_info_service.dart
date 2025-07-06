import "package:logger/logger.dart";
import "package:package_info_plus/package_info_plus.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/initializable_service.dart";

/// Service to retrieve application information such as the version.
class AppInfoService with InitializableService {
  final Logger _logger = getLogger("AppInfoService");

  PackageInfo? _packageInfo;

  /// Returns the application version.
  /// If the package info is not initialized, it returns "unknown".
  String get appVersion {
    if (_packageInfo == null) {
      _logger.w("Package info is not initialized, returning 'unknown'.");
      return "unknown";
    }

    return _packageInfo!.version;
  }

  @override
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (e, stackTrace) {
      _logger.e(
        "Failed to load package info",
        error: e,
        stackTrace: stackTrace,
      );
      _packageInfo = null; // Fallback to null if loading fails
    }
  }
}
