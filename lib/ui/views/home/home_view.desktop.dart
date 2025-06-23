import 'package:buzzer/ui/widgets/common/create_room_form/create_room_form.dart';
import 'package:buzzer/ui/widgets/common/join_room_form/join_room_form.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:buzzer/ui/common/ui_helpers.dart';

import 'home_viewmodel.dart';

class HomeViewDesktop extends ViewModelWidget<HomeViewModel> {
  const HomeViewDesktop({super.key});

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    const horizontalPadding = 64.0;

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
                const Text("Buzzer").h1,
                FocusTraversalGroup(
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text("Login").h3,
                      ),
                      horizontalSpaceSmall,
                      TextButton(
                        onPressed: () {},
                        child: const Text("Register").h3,
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
                                "Create a room for your game or event, and invite others to join.")
                            .base,
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
                                "Join an existing room to participate in a game or event.")
                            .base,
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
}
