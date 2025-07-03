import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/widgets/input_features/random_name_input_feature.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/ui/common/ui_helpers.dart";

import "join_room_form_model.dart";

class JoinRoomForm extends MvvmView<JoinRoomFormModel> {
  const JoinRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    JoinRoomFormModel viewModel,
    Widget? child,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: const Text("Join a room").h3),
          verticalSpaceMedium,
          const Text(
            "Join an existing room to participate in a game or event.",
          ).base,
          verticalSpaceMedium,
          FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room name
                const Text("Join code").base.bold,
                verticalSpaceTiny,
                TextField(controller: viewModel.joinCodeController),
                verticalSpaceSmall,
                // User name
                const Text("Your name").base.bold,
                verticalSpaceTiny,
                TextField(
                  controller: viewModel.userNameController,
                  features: [
                    RandomNameInputFeature(
                      visibility: viewModel.isRandomNameFeatureVisible
                          ? InputFeatureVisibility.always
                          : InputFeatureVisibility.never,
                      generateName: viewModel.generateRandomName,
                    ),
                  ],
                ),
                verticalSpaceMedium,
                // Action buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Visibility(
                        visible: viewModel.hasError,
                        child: _buildErrorMessage(viewModel.error(viewModel)),
                      ),
                    ),
                    Button.primary(
                      onPressed: () async =>
                          await viewModel.onPressedJoinRoom(context),
                      enabled: !viewModel.isBusy,
                      child: const Text("Join room"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onDispose(JoinRoomFormModel viewModel) {
    super.onDispose(viewModel);
    viewModel.disposeForm();
  }

  @override
  JoinRoomFormModel viewModelBuilder(BuildContext context) =>
      JoinRoomFormModel();

  Widget _buildErrorMessage(dynamic error) {
    const textStyle = TextStyle(color: Colors.red);

    if (error is String) {
      return Text(error, style: textStyle).bold;
    } else {
      return Text("Error: ${error.toString()}", style: textStyle).bold;
    }
  }
}
