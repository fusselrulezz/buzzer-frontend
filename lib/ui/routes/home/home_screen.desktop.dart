import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

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
    const horizontalPadding = 64.0;

    const trPrefix = HomeScreen.trPrefix;

    return Scaffold(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32.0,
              horizontal: horizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$trPrefix.branding".tr()).h1,
                FocusTraversalGroup(
                  child: Tooltip(
                    tooltip: (context) =>
                        Text("$trPrefix.topnav.settings.tooltip".tr()),
                    child: Button(
                      style: const ButtonStyle.ghostIcon(),
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
