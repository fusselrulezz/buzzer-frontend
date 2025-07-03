import "package:adaptive_theme/adaptive_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/widgets.dart";
import "package:logger/logger.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/ui/common/shadcn_adaptive_theme.dart";

class SettingsDialogModel extends BaseViewModel {
  final Logger _logger = getLogger("SettingsDialogModel");

  final List<AdaptiveThemeMode> themeModes = [
    AdaptiveThemeMode.light,
    AdaptiveThemeMode.dark,
    AdaptiveThemeMode.system,
  ];

  AdaptiveThemeMode themeMode(BuildContext context) =>
      ShadcnAdaptiveTheme.of(context).mode;

  void onThemeChanged(
    BuildContext context,
    AdaptiveThemeMode? adaptiveThemeMode,
  ) {
    if (adaptiveThemeMode == null) return;

    ShadcnAdaptiveTheme.of(context).setThemeMode(adaptiveThemeMode);
    notifyListeners();
  }

  String themeModeName(AdaptiveThemeMode mode) {
    return switch (mode) {
      AdaptiveThemeMode.light => "theme.modes.light.name".tr(),
      AdaptiveThemeMode.dark => "theme.modes.dark.name".tr(),
      AdaptiveThemeMode.system => "theme.modes.system.name".tr(),
    };
  }

  List<Locale> getSupportedLocales(BuildContext context) {
    final easyLocalization = EasyLocalization.of(context);

    if (easyLocalization == null) {
      // This should really not ever happen, but if it does, we return English
      // as a fallback locale to prevent crashes.
      _logger.w("Localization is not initialized, returning default locales.");
      return [const Locale("en")];
    }

    return easyLocalization.supportedLocales;
  }

  Locale locale(BuildContext context) {
    final easyLocalization = EasyLocalization.of(context);

    if (easyLocalization == null) {
      // This should really not ever happen, but if it does, we return English
      // as a fallback locale to prevent crashes.
      _logger.w("Localization is not initialized, returning default locale.");
      return const Locale("en");
    }

    return easyLocalization.locale;
  }

  String localeName(Locale locale) {
    return _localeNameTranslationKey(locale).tr();
  }

  String _localeNameTranslationKey(Locale locale) {
    StringBuffer sb = StringBuffer();

    sb.write("locale.names.");
    sb.write(locale.toLanguageTag());
    sb.write(".name");

    return sb.toString();
  }

  void onLocaleChanged(BuildContext context, Locale? value) {
    if (value == null) return;

    EasyLocalization.of(context)?.setLocale(value);
    notifyListeners();
  }
}
