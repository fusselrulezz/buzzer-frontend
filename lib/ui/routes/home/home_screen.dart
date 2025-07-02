import "package:auto_route/auto_route.dart";
import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/common/create_room_form/create_room_form.dart";
import "package:buzzer/ui/widgets/common/join_room_form/join_room_form.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 64.0;

    const trPrefix = "routes.home";

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
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text("$trPrefix.topnav.login.caption".tr()).h3,
                      ),
                      horizontalSpaceSmall,
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "$trPrefix.topnav.register.caption".tr(),
                        ).h3,
                      ),
                      horizontalSpaceSmall,
                      Button(
                        style: const ButtonStyle.ghostIcon(),
                        onPressed: () => _showSettingsPopover(context),
                        child: const Icon(BootstrapIcons.gear, size: 24.0),
                      ),
                    ],
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: const Text("Create a room").h3),
                        verticalSpaceMedium,
                        const Text(
                          "Create a room for your game or event, and invite others to join.",
                        ).base,
                        verticalSpaceMedium,
                        const CreateRoomForm(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  const VerticalDivider(),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(child: const Text("Join a room").h3),
                        verticalSpaceMedium,
                        const Text(
                          "Join an existing room to participate in a game or event.",
                        ).base,
                        verticalSpaceMedium,
                        const JoinRoomForm(),
                      ],
                    ),
                  ),
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
