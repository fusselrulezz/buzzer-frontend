import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/view_model_widget.dart";

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
      headers: [
        AppBar(
          title: Text(viewModel.roomName),
          subtitle: Text(
            "$trPrefix.header.info.playing_as".tr(
              namedArgs: {"playerName": viewModel.userName},
            ),
          ),
          leading: const [],
          trailing: [
            OutlineButton(
              density: ButtonDensity.icon,
              onPressed: () {},
              child: const Icon(Icons.settings),
            ),
          ],
        ),
      ],
      child: const Placeholder(),
    );
  }
}
