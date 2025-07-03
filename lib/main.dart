import "package:adaptive_theme/adaptive_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/app_router.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/app/service_registrant.dart";
import "package:buzzer/services/system_config_service.dart";
import "package:buzzer/ui/common/shadcn_adaptive_theme.dart";

final _logger = getLogger("main");

late final Stopwatch _stopwatch;
bool isInitialStart = true;

Future<void> main() async {
  _stopwatch = Stopwatch()..start();

  _logger.i("Starting Buzzer app...");

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await registerServices();

  await locator<SystemConfigService>().ensureInitialized();

  _logger.i("Core initialization complete, running app...");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    _stopwatch.stop();

    const defaultLocale = Locale("en");
    const supportedLocales = [defaultLocale];

    if (isInitialStart) {
      isInitialStart = false;
      _logger.i("Time to first build: ${_stopwatch.elapsedMilliseconds} ms");
    } else {
      _logger.i("(Re)building root widget...");
    }

    return EasyLocalization(
      supportedLocales: supportedLocales,
      fallbackLocale: defaultLocale,
      path: "assets/lang",
      useFallbackTranslations: true,
      child: ShadcnAdaptiveTheme(
        light: ThemeData(colorScheme: ColorSchemes.lightNeutral(), radius: 0.5),
        dark: ThemeData(colorScheme: ColorSchemes.darkNeutral(), radius: 0.5),
        initial: AdaptiveThemeMode.system,
        debugShowFloatingThemeButton: false,
        builder: (context, theme, darkTheme) {
          return ShadcnApp.router(
            routerConfig: _appRouter.config(),
            title: "Buzzer",
            theme: theme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: supportedLocales,
            localizationsDelegates: context.localizationDelegates,
          );
        },
      ),
    );
  }
}
