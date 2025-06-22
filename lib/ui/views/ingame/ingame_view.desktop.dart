import 'package:buzzer/ui/widgets/common/join_code_display/join_code_display.dart';
import 'package:buzzer/ui/widgets/common/player_list/player_list.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:buzzer/ui/common/ui_helpers.dart';

import 'ingame_viewmodel.dart';

class IngameViewDesktop extends ViewModelWidget<IngameViewModel> {
  const IngameViewDesktop({super.key});

  @override
  Widget build(BuildContext context, IngameViewModel viewModel) {
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
                    Text("Playing as ${viewModel.userName}").h3,
                    verticalSpaceTiny,
                    Text("Room ID: ${viewModel.gameContext.roomId}")
                        .muted
                        .small,
                  ],
                ),
                Row(
                  children: [
                    JoinCodeDisplay(joinCode: viewModel.joinCode),
                    horizontalSpaceMedium,
                    Button.destructive(
                      onPressed: viewModel.onPressedLeaveRoom,
                      child: const Text("Leave Room"),
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
                  PlayerList(gameContext: viewModel.gameContext),
                  const Expanded(
                    child: Text("Buzzer here!"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
