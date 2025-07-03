import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";

import "join_code_display_model.dart";

class JoinCodeDisplay extends MvvmView<JoinCodeDisplayModel> {
  final String _joinCode;

  const JoinCodeDisplay({super.key, required String joinCode})
    : _joinCode = joinCode;

  @override
  Widget builder(
    BuildContext context,
    JoinCodeDisplayModel viewModel,
    Widget? child,
  ) {
    const trPrefix = JoinCodeDisplayModel.trPrefix;

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$trPrefix.title".tr()),
            horizontalSpaceMedium,
            _buildJoinCodeDisplay(viewModel),
          ],
        ),
        horizontalSpaceSmall,
        Button(
          style: const ButtonStyle.ghostIcon(),
          onPressed: () async => await viewModel.onPressedCopy(context),
          child: const Icon(BootstrapIcons.copy),
        ),
        horizontalSpaceTiny,
        Button(
          style: const ButtonStyle.ghostIcon(),
          onPressed: viewModel.onPressedToggleVisibility,
          child: viewModel.isCodeVisible
              ? const Icon(BootstrapIcons.eye)
              : const Icon(BootstrapIcons.eyeSlash),
        ),
      ],
    );
  }

  /// Controls how the join code is displayed based on the visibility state.
  // When editing this code, ensure that position does not change so that the
  // text will not jump around when toggling visibility.
  Widget _buildJoinCodeDisplay(JoinCodeDisplayModel viewModel) {
    final display = Text(viewModel.joinCode).h3;

    if (viewModel.isCodeVisible) {
      return display;
    } else if (viewModel.hideWithoutBlur) {
      return Visibility.maintain(visible: false, child: display);
    } else {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Text(viewModel.joinCode).h3,
      );
    }
  }

  @override
  JoinCodeDisplayModel viewModelBuilder(BuildContext context) =>
      JoinCodeDisplayModel(joinCode: _joinCode);
}
