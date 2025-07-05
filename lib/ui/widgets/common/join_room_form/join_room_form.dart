import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer/ui/widgets/input_features/random_name_input_feature.dart";

import "join_room_form_model.dart";

class JoinRoomForm extends MvvmView<JoinRoomFormModel> {
  const JoinRoomForm({super.key});

  @override
  Widget builder(
    BuildContext context,
    JoinRoomFormModel viewModel,
    Widget? child,
  ) {
    const trPrefix = "widgets.join_room_form";

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
                // Join code
                Text("$trPrefix.fields.join_code.label".tr()).base.bold,
                verticalSpaceTiny,
                TextField(controller: viewModel.joinCodeController),
                verticalSpaceSmall,
                // User name
                Text("$trPrefix.fields.player_name.label".tr()).base.bold,
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
                    Button.primary(
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
