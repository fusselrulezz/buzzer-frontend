import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/view_model_widget.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/common/buzzer_button.dart";
import "package:buzzer/ui/widgets/common/join_code_display/join_code_display.dart";
import "package:buzzer/ui/widgets/common/player_list/player_list.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";

import "ingame_screen.dart";
import "ingame_screen_model.dart";

/// The desktop variant of the ingame screen.
class IngameScreenDesktop extends ViewModelWidget<IngameScreenModel> {
  /// Creates a new [IngameScreenDesktop] widget.
  const IngameScreenDesktop({super.key});

  @override
  Widget build(BuildContext context, IngameScreenModel viewModel) {
    const trPrefix = IngameScreen.trPrefix;

    const double horizontalPadding = 64.0;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.roomName).h1,
                    verticalSpaceTiny,
                    Row(
                      children: [
                        Text(
                          "$trPrefix.header.info.playing_as".tr(
                            namedArgs: {"playerName": viewModel.userName},
                          ),
                        ).h3,
                        horizontalSpaceSmall,
                        if (viewModel.isHost) ...[
                          PrimaryBadge(
                            child: Text(
                              "$trPrefix.header.info.badge_host".tr(),
                            ),
                          ),
                        ],
                      ],
                    ),
                    verticalSpaceTiny,
                    Text(
                      "$trPrefix.header.info.room_id".tr(
                        namedArgs: {"roomId": viewModel.gameContext.roomId},
                      ),
                    ).muted.small,
                  ],
                ),
                Row(
                  children: [
                    JoinCodeDisplay(joinCode: viewModel.joinCode),
                    horizontalSpaceMedium,
                    Button(
                      style: const ButtonStyle.ghostIcon(),
                      onPressed: () => _showSettingsPopover(context),
                      child: const Icon(BootstrapIcons.gear, size: 24.0),
                    ),
                    horizontalSpaceSmall,
                    Button.destructive(
                      onPressed: () async =>
                          await viewModel.onPressedLeaveRoom(context),
                      child: Text("$trPrefix.header.actions.leave.label".tr()),
                    ),
                  ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlayerList(
                    players: viewModel.players,
                    playerBuzzerStates: viewModel.playerBuzzerStates,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Button(
                                style: const ButtonStyle.ghostIcon(),
                                enabled: viewModel.resetButtonEnabled,
                                onPressed: viewModel.onPressedResetBuzzer,
                                child: const Icon(
                                  BootstrapIcons.arrowClockwise,
                                  size: 32.0,
                                ),
                              ),
                            ],
                          ),
                        ),
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
