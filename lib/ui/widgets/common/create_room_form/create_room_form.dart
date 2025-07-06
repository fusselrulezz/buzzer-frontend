import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";

import "create_room_form_model.dart";

/// A form widget for creating a new game room, allowing users to enter
/// a room name and their player name.
class CreateRoomForm extends MvvmView<CreateRoomFormModel> {
  /// Creates a new [CreateRoomForm] widget.
  const CreateRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateRoomFormModel viewModel,
    Widget? child,
  ) {
    const trPrefix = "widgets.create_room_form";

    final theme = Theme.of(context);
    final progressHeight = theme.scaling * 2;
    final totalHeight = (mediumSize - progressHeight) / 2;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("$trPrefix.title".tr()).h3),
          verticalSpaceMedium,
          Text("$trPrefix.description".tr()).base,
          verticalSpaceMedium,
          FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Room name
                Text("$trPrefix.fields.room_name.label".tr()).base.bold,
                verticalSpaceTiny,
                TextField(
                  controller: viewModel.roomNameController,
                  placeholder: Text("$trPrefix.fields.room_name.hint".tr()),
                ),
                verticalSpaceSmall,
                // User name
                Text("$trPrefix.fields.player_name.label".tr()).base.bold,
                verticalSpaceTiny,
                TextField(controller: viewModel.userNameController),
                // Progress and spacing
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: totalHeight,
                    horizontal: tinySize,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: progressHeight,
                    child: viewModel.isBusy ? LinearProgressIndicator() : null,
                  ),
                ),
                // Action buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: Text("$trPrefix.actions.create.label".tr()),
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
