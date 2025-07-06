import "package:adaptive_theme/adaptive_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/widgets.dart";
import "package:logger/logger.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/ui/common/shadcn_adaptive_theme.dart";

/// The view model for the settings dialog, managing the state and logic
/// for changing the theme and locale settings of the application.
class SettingsDialogModel extends BaseViewModel {
  final Logger _logger = getLogger("SettingsDialogModel");

  /// The list of available theme modes for the application.
  final List<AdaptiveThemeMode> themeModes = [
    AdaptiveThemeMode.light,
    AdaptiveThemeMode.dark,
    AdaptiveThemeMode.system,
  ];

  /// Resolves the current theme mode from the context.
  AdaptiveThemeMode themeMode(BuildContext context) =>
      ShadcnAdaptiveTheme.of(context).mode;

  /// Will be called when the user has picked a new theme mode.
  void onThemeChanged(
    BuildContext context,
    AdaptiveThemeMode? adaptiveThemeMode,
  ) {
    if (adaptiveThemeMode == null) return;

    ShadcnAdaptiveTheme.of(context).setThemeMode(adaptiveThemeMode);
    notifyListeners();
  }

  /// Returns the name of the theme mode for display purposes.
  String themeModeName(AdaptiveThemeMode mode) {
    return switch (mode) {
      AdaptiveThemeMode.light => "theme.modes.light.name".tr(),
      AdaptiveThemeMode.dark => "theme.modes.dark.name".tr(),
      AdaptiveThemeMode.system => "theme.modes.system.name".tr(),
    };
  }

  /// Returns a list of supported locales for the application.
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

  /// Resolves the current locale from the context.
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

  /// Returns the name of the locale for display purposes.
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

  /// Will be called when the user has picked a new locale.
  void onLocaleChanged(BuildContext context, Locale? value) {
    if (value == null) return;

    EasyLocalization.of(context)?.setLocale(value);
    notifyListeners();
  }
}
