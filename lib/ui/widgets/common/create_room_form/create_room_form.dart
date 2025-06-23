import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:buzzer/ui/common/ui_helpers.dart';
import 'package:buzzer/ui/widgets/common/create_room_form/create_room_form.form.dart';

import 'create_room_form_model.dart';

@FormView(fields: [
  FormTextField(name: 'roomName'),
  FormTextField(name: 'userName'),
])
class CreateRoomForm extends StackedView<CreateRoomFormModel>
    with $CreateRoomForm {
  const CreateRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    CreateRoomFormModel viewModel,
    Widget? child,
  ) {
    return FocusTraversalGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room name
          const Text("Room name").base.bold,
          verticalSpaceTiny,
          TextField(
            controller: roomNameController,
            placeholder: const Text("Very fun room name"),
          ),
          verticalSpaceSmall,
          // User name
          const Text("Your name").base.bold,
          verticalSpaceTiny,
          TextField(
            controller: userNameController,
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
                onPressed: viewModel.onPressedCreateRoom,
                enabled: !viewModel.isBusy,
                child: const Text("Create room"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void onViewModelReady(CreateRoomFormModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(CreateRoomFormModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  CreateRoomFormModel viewModelBuilder(
    BuildContext context,
  ) =>
      CreateRoomFormModel();

  Widget _buildErrorMessage(dynamic error) {
    const textStyle = TextStyle(
      color: Colors.red,
    );

    if (error is String) {
      return Text(
        error,
        style: textStyle,
      ).bold;
    } else {
      return Text(
        "Error: ${error.toString()}",
        style: textStyle,
      ).bold;
    }
  }
}
