import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

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
      appBar: AppBar(
        title: Text("$trPrefix.branding".tr()),
        actions: [
          ShadIconButton.ghost(
            onPressed: () => _showSettingsPopover(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: ShadTabs<int>(
          value: 0,
          gap: largeSize,
          tabs: [
            ShadTab(value: 0, content: CreateRoomForm(), child: Text("Create")),
            ShadTab(value: 1, content: JoinRoomForm(), child: Text("Join")),
          ],
        ),
      ),
    );
  }

  void _showSettingsPopover(BuildContext context) {
    showDialog(context: context, builder: (context) => const SettingsDialog());
  }
}
