import "package:buzzer/app/service_locator.dart";
import "package:buzzer/services/api_service.dart";
import "package:buzzer/services/app_info_service.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer/services/game_context_service.dart";
import "package:buzzer/services/random_name_service.dart";
import "package:buzzer/services/secure_storage_service.dart";
import "package:buzzer/services/system_config_service.dart";

/// Registers services for dependency injection.
/// This function should be called during the app initialization phase.
Future<void> registerServices() async {
  locator.registerLazySingleton(() => SystemConfigService());

  final secureStorageService = SecureStorageService();
  await secureStorageService.init();
  locator.registerSingleton(secureStorageService);

  locator.registerSingleton(RandomNameService());

  final appInfoService = AppInfoService();
  await appInfoService.init();
  locator.registerSingleton(appInfoService);

  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => BuzzerService());

  locator.registerLazySingleton(() => GameContextService());
}
