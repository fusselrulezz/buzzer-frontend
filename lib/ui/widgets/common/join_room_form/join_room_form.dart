import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/generate_random_name_button.dart";
import "package:buzzer/ui/common/ui_helpers.dart";

import "join_room_form_model.dart";

/// A form widget for joining an existing game room, allowing users to enter
/// a join code and their player name.
class JoinRoomForm extends MvvmView<JoinRoomFormModel> {
  /// Creates a new [JoinRoomForm] widget.
  const JoinRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    JoinRoomFormModel viewModel,
    Widget? child,
  ) {
    const trPrefix = "widgets.join_room_form";

    const progressHeight = 2.0;
    const totalHeight = (mediumSize - progressHeight) / 2;

    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text("$trPrefix.title".tr(), style: theme.textTheme.h3)),
        verticalSpaceMedium,
        Text("$trPrefix.description".tr()),
        verticalSpaceMedium,
        FocusTraversalGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Join code
              Text(
                "$trPrefix.fields.join_code.label".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              verticalSpaceTiny,
              ShadInput(controller: viewModel.joinCodeController),
              verticalSpaceSmall,
              // User name
              Text(
                "$trPrefix.fields.player_name.label".tr(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              verticalSpaceTiny,
              ShadInput(
                controller: viewModel.userNameController,
                trailing: GenerateRandomNameButton(
                  onNameGenerated: (name) {
                    viewModel.userNameController.text = name;
                  },
                ),
              ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Visibility(
                      visible: viewModel.hasError,
                      child: _buildErrorMessage(viewModel.error(viewModel)),
                    ),
                  ),
                  ShadButton(
                    onPressed: () async =>
                        await viewModel.onPressedJoinRoom(context),
                    enabled: !viewModel.isBusy,
                    child: Text("$trPrefix.actions.join.label".tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
    const textStyle = TextStyle(color: Colors.red, fontWeight: FontWeight.bold);

    if (error is String) {
      return Text(error, style: textStyle);
    } else {
      return Text("Error: ${error.toString()}", style: textStyle);
    }
  }
}
