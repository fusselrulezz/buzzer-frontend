import "package:buzzer/ui/common/ui_helpers.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";

import "create_room_form_model.dart";

class CreateRoomForm extends MvvmView<CreateRoomFormModel> {
  const CreateRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateRoomFormModel viewModel,
    Widget? child,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: const Text("Create a room").h3),
          verticalSpaceMedium,
          const Text(
            "Create a room for your game or event, and invite others to join.",
          ).base,
          verticalSpaceMedium,
          FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room name
                const Text("Room name").base.bold,
                verticalSpaceTiny,
                TextField(
                  controller: viewModel.roomNameController,
                  placeholder: const Text("Very fun room name"),
                ),
                verticalSpaceSmall,
                // User name
                const Text("Your name").base.bold,
                verticalSpaceTiny,
                TextField(controller: viewModel.userNameController),
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
                          await viewModel.onPressedCreateRoom(context),
                      enabled: !viewModel.isBusy,
                      child: const Text("Create room"),
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
  CreateRoomFormModel viewModelBuilder(BuildContext context) =>
      CreateRoomFormModel();

  @override
  void onDispose(CreateRoomFormModel viewModel) {
    super.onDispose(viewModel);
    viewModel.disposeForm();
  }

  Widget _buildErrorMessage(dynamic error) {
    const textStyle = TextStyle(color: Colors.red);

    if (error is String) {
      return Text(error, style: textStyle).bold;
    } else {
      return Text("Error: ${error.toString()}", style: textStyle).bold;
    }
  }
}
