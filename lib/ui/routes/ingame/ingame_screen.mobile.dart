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

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(viewModel.roomName),
            Text(
              "$trPrefix.header.info.playing_as".tr(
                namedArgs: {"playerName": viewModel.userName},
              ),
              style: ShadTheme.of(
                context,
              ).textTheme.small.merge(ShadTheme.of(context).textTheme.muted),
            ),
          ],
        ),
        actions: [
          ShadButton.ghost(
            onPressed: () => _showSettingsPopover(context),
            child: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Placeholder(),
    );
  }

  void _showSettingsPopover(BuildContext context) {
    showDialog(context: context, builder: (context) => const SettingsDialog());
  }
}
