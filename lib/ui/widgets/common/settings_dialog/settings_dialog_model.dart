import "package:adaptive_theme/adaptive_theme.dart";
import "package:buzzer/ui/common/shadcn_adaptive_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/widgets.dart";

import "package:buzzer/mvvm/base_view_models.dart";

class SettingsDialogModel extends BaseViewModel {
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
      AdaptiveThemeMode.light => "Light",
      AdaptiveThemeMode.dark => "Dark",
      AdaptiveThemeMode.system => "System",
    };
  }

  List<Locale> getSupportedLocales(BuildContext context) {
    return EasyLocalization.of(context)?.supportedLocales ?? [];
  }

  Locale locale(BuildContext context) {
    return EasyLocalization.of(context)?.locale ?? const Locale("en");
  }

  String localeName(Locale locale) {
    return locale.languageCode;
  }

  void onLocaleChanged(BuildContext context, Locale? value) {
    if (value == null) return;

    EasyLocalization.of(context)?.setLocale(value);
    notifyListeners();
  }
}
