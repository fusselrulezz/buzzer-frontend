import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/common/buzzer_button.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/mvvm/view_model_widget.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";

import "ingame_screen.dart";
import "ingame_screen_model.dart";

/// The mobile variant of the ingame screen.
class IngameScreenMobile extends ViewModelWidget<IngameScreenModel> {
  /// Creates a new [IngameScreenMobile] widget.
  const IngameScreenMobile({super.key});

  @override
  Widget build(BuildContext context, IngameScreenModel viewModel) {
    const trPrefix = IngameScreen.trPrefix;

    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(viewModel.roomName),
            Row(
              children: [
                Text(
                  "$trPrefix.header.info.playing_as".tr(
                    namedArgs: {"playerName": viewModel.userName},
                  ),
                  style: theme.textTheme.small.merge(theme.textTheme.muted),
                ),
                horizontalSpaceSmall,
                if (viewModel.isHost) ...[
                  ShadBadge(
                    child: Text("$trPrefix.header.info.badge_host".tr()),
                  ),
                ],
              ],
            ),
          ],
        ),
        actionsPadding: EdgeInsets.all(8.0),
        actions: [
          ShadIconButton.ghost(
            onPressed: () => _showSettingsPopover(context),
            icon: const Icon(Icons.settings, size: 24),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BuzzerButton(
            enabled: viewModel.buzzerEnabled,
            onPressed: viewModel.onPressedBuzzer,
          ),
          verticalSpaceLarge,
          Visibility.maintain(
            visible: viewModel.resetButtonVisible,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadIconButton.ghost(
                  enabled: viewModel.resetButtonEnabled,
                  onPressed: viewModel.onPressedResetBuzzer,
                  icon: const Icon(BootstrapIcons.arrow_clockwise, size: 32.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsPopover(BuildContext context) {
    showDialog(context: context, builder: (context) => const SettingsDialog());
  }
}
