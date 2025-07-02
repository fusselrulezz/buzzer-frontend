import "package:adaptive_theme/adaptive_theme.dart";
import "package:flutter/widgets.dart" as widgets;
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog_model.dart";

class SettingsDialog extends MvvmView<SettingsDialogModel> {
  const SettingsDialog({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsDialogModel viewModel,
    Widget? child,
  ) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final spacing = scaling * 16;

    final themeItemButtons = viewModel.themeModes
        .map(
          (e) => SelectItemButton(
            value: e,
            child: Text(viewModel.themeModeName(e)),
          ),
        )
        .toList();

    return AlertDialog(
      content: SizedBox(
        width: 300.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Settings").h3,
            verticalSpaceSmall,
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: theme.colorScheme.foreground),
                child: widgets.Table(
                  columnWidths: const {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    widgets.TableRow(
                      children: [
                        const Text("Theme").textSmall
                            .withAlign(AlignmentDirectional.centerEnd)
                            .withMargin(right: 16 * scaling)
                            .sized(height: 32 * scaling)
                            .withPadding(top: 0, left: 16 * scaling),
                        Select<AdaptiveThemeMode>(
                          value: viewModel.themeMode(context),
                          itemBuilder: (context, value) =>
                              Text(viewModel.themeModeName(value)),
                          onChanged: (value) =>
                              viewModel.onThemeChanged(context, value),
                          popup: (context) => SelectPopup<AdaptiveThemeMode>(
                            items: SelectItemList(children: themeItemButtons),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
