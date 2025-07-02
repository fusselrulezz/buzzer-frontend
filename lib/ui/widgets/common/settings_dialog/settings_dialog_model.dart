import "package:adaptive_theme/adaptive_theme.dart";
import "package:buzzer/ui/common/shadcn_adaptive_theme.dart";
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
}
