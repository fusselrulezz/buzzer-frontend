import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import 'package:buzzer/ui/common/ui_helpers.dart';
import 'package:buzzer/ui/widgets/common/join_room_form/join_room_form.form.dart';

import 'join_room_form_model.dart';

@FormView(fields: [
  FormTextField(name: 'joinCode'),
  FormTextField(name: 'userName'),
])
class JoinRoomForm extends StackedView<JoinRoomFormModel> with $JoinRoomForm {
  const JoinRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    JoinRoomFormModel viewModel,
    Widget? child,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Room name
        const Text("Join code").base.bold,
        verticalSpaceTiny,
        TextField(
          controller: joinCodeController,
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
              onPressed: viewModel.onPressedJoinRoom,
              child: const Text("Join room"),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void onViewModelReady(JoinRoomFormModel viewModel) {
    syncFormWithViewModel(viewModel);
  }

  @override
  void onDispose(JoinRoomFormModel viewModel) {
    super.onDispose(viewModel);
    disposeForm();
  }

  @override
  JoinRoomFormModel viewModelBuilder(
    BuildContext context,
  ) =>
      JoinRoomFormModel();

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
