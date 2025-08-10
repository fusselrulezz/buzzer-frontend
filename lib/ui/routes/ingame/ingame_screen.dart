import "package:auto_route/auto_route.dart";
import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/routes/ingame/ingame_screen_model.dart";
import "package:buzzer/ui/widgets/common/buzzer_button.dart";
import "package:buzzer/ui/widgets/common/join_code_display/join_code_display.dart";
import "package:buzzer/ui/widgets/common/player_list/player_list.dart";
import "package:buzzer/ui/widgets/common/settings_dialog/settings_dialog.dart";
import "package:shadcn_ui/shadcn_ui.dart";

/// The ingame screen of the application, which displays the current game
/// state, player list, and buzzer functionality.
@RoutePage()
class IngameScreen extends MvvmView<IngameScreenModel> {
  /// Creates a new [IngameScreen] widget.
  const IngameScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    IngameScreenModel viewModel,
    Widget? child,
  ) {
    const trPrefix = "routes.ingame";

    const double horizontalPadding = 64.0;

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      viewModel.roomName,
                      style: ShadTheme.of(context).textTheme.h1,
                    ),
                    verticalSpaceTiny,
                    Row(
                      children: [
                        Text(
                          "$trPrefix.header.info.playing_as".tr(
                            namedArgs: {"playerName": viewModel.userName},
                          ),
                          style: ShadTheme.of(context).textTheme.h3,
                        ),
                        horizontalSpaceSmall,
                        if (viewModel.isHost) ...[
                          ShadBadge(
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
                      // TODO: Make sure this merge thing works...
                      style: ShadTheme.of(context).textTheme.small.merge(
                        ShadTheme.of(context).textTheme.muted,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    JoinCodeDisplay(joinCode: viewModel.joinCode),
                    horizontalSpaceMedium,
                    ShadButton.ghost(
                      onPressed: () => _showSettingsPopover(context),
                      child: const Icon(BootstrapIcons.gear, size: 24.0),
                    ),
                    horizontalSpaceSmall,
                    ShadButton.destructive(
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
                              ShadButton.ghost(
                                enabled: viewModel.resetButtonEnabled,
                                onPressed: viewModel.onPressedResetBuzzer,
                                child: const Icon(
                                  BootstrapIcons.arrow_clockwise,
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

  @override
  IngameScreenModel viewModelBuilder(BuildContext context) =>
      IngameScreenModel();
}
