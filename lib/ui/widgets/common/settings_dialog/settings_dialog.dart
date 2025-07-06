import "package:adaptive_theme/adaptive_theme.dart";
import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";

import "settings_dialog_model.dart";
import "settings_dialog_table.dart";
import "settings_dialog_table_item.dart";

/// A dialog widget for changing application settings such as theme and locale.
class SettingsDialog extends MvvmView<SettingsDialogModel> {
  /// Creates a new [SettingsDialog] widget.
  const SettingsDialog({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsDialogModel viewModel,
    Widget? child,
  ) {
    const trPrefix = "widgets.settings_dialog";

    return AlertDialog(
      content: SizedBox(
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$trPrefix.title".tr()).h3,
            verticalSpaceSmall,
            SettingsDialogTable(
              maxWidth: 400.0,
              items: [
                // New theme selection
                SettingsDialogTableItem.select<AdaptiveThemeMode>(
                  items: viewModel.themeModes,
                  label: "$trPrefix.theme.label".tr(),
                  value: viewModel.themeMode(context),
                  displayName: viewModel.themeModeName,
                  onChanged: viewModel.onThemeChanged,
                ),
                // new locale selection
                SettingsDialogTableItem.select<Locale>(
                  items: viewModel.getSupportedLocales(context),
                  label: "$trPrefix.locale.label".tr(),
                  value: viewModel.locale(context),
                  displayName: viewModel.localeName,
                  onChanged: viewModel.onLocaleChanged,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  SettingsDialogModel viewModelBuilder(BuildContext context) =>
      SettingsDialogModel();
}
