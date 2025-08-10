import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/ui/widgets/common/create_room_form/create_room_form.dart";
import "package:buzzer/ui/widgets/common/join_room_form/join_room_form.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";

import "home_screen.dart";

/// The desktop variant of the home screen of the application.
class HomeScreenDesktop extends StatelessWidget {
  /// Creates a new [HomeScreenDesktop] widget.
  const HomeScreenDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    const trPrefix = HomeScreen.trPrefix;
    const horizontalPadding = 64.0;

    final theme = ShadTheme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: horizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$trPrefix.branding".tr(), style: theme.textTheme.h1),
                FocusTraversalGroup(
                  child: Tooltip(
                    message: "$trPrefix.topnav.settings.tooltip".tr(),
                    child: ShadButton.ghost(
                      onPressed: () => _showSettingsPopover(context),
                      child: const Icon(BootstrapIcons.gear, size: 24.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: horizontalPadding,
              ),
              child: Row(
                spacing: 16.0,
                children: [
                  const CreateRoomForm(),
                  const VerticalDivider(),
                  const JoinRoomForm(),
                ],
              ),
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
