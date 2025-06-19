import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

import 'package:buzzer/app/app.bottomsheets.dart';
import 'package:buzzer/app/app.dialogs.dart';
import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.router.dart';
import 'package:buzzer/services/system_config_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  setPathUrlStrategy();
  await setupLocator(stackedRouter: stackedRouter);

  setupDialogUi();
  setupBottomSheetUi();

  await locator<SystemConfigService>().ensureInitialized();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultLocale = Locale("en");

    return EasyLocalization(
      supportedLocales: const [
        defaultLocale,
      ],
      fallbackLocale: defaultLocale,
      path: "assets/lang",
      child: ResponsiveApp(
        builder: (context) => ShadcnApp.router(
          debugShowCheckedModeBanner: false,
          routerDelegate: stackedRouter.delegate(),
          routeInformationParser: stackedRouter.defaultRouteParser(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            colorScheme: ColorSchemes.lightGray(),
            radius: 0.5,
          ),
        ),
      ).animate().fadeIn(
            delay: const Duration(milliseconds: 50),
            duration: const Duration(milliseconds: 400),
          ),
    );
  }
}
