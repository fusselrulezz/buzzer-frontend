import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/common/create_room_form/create_room_form.dart";
import "package:buzzer/ui/widgets/common/join_room_form/join_room_form.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";

import "home_screen.dart";

/// The mobile variant of the home screen of the application.
class HomeScreenMobile extends StatefulWidget {
  /// Creates a new [HomeScreenMobile] widget.
  const HomeScreenMobile({super.key});

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    const trPrefix = HomeScreen.trPrefix;

    return Scaffold(
      headers: [
        AppBar(
          title: Text("$trPrefix.branding".tr()),
          leading: const [],
          trailing: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () => _showSettingsPopover(context),
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          children: [
            Tabs(
              index: index,
              children: const [
                TabItem(child: Text("Create")),
                TabItem(child: Text("Join")),
              ],
              onChanged: (int value) {
                setState(() {
                  index = value;
                });
              },
            ),
            verticalSpaceLarge,
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  void _showSettingsPopover(BuildContext context) {
    showDialog(context: context, builder: (context) => const SettingsDialog());
  }

  Widget _buildContent(BuildContext context) {
    return index == 0 ? const CreateRoomForm() : const JoinRoomForm();
  }
}
