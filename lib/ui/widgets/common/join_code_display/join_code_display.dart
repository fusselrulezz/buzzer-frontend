import "dart:ui";

import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:easy_localization/easy_localization.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/common/ui_helpers.dart";
import "package:flutter/widgets.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "join_code_display_model.dart";

/// A widget that displays a join code for a game room, allowing users to
/// copy it to the clipboard or toggle its visibility.
class JoinCodeDisplay extends MvvmView<JoinCodeDisplayModel> {
  final String _joinCode;

  /// Creates a new [JoinCodeDisplay] widget.
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
            _buildJoinCodeDisplay(context, viewModel),
          ],
        ),
        horizontalSpaceSmall,
        ShadButton.ghost(
          onPressed: () async => await viewModel.onPressedCopy(context),
          child: const Icon(BootstrapIcons.copy),
        ),
        horizontalSpaceTiny,
        ShadButton.ghost(
          onPressed: viewModel.onPressedToggleVisibility,
          child: viewModel.isCodeVisible
              ? const Icon(BootstrapIcons.eye)
              : const Icon(BootstrapIcons.eye_slash),
        ),
      ],
    );
  }

  /// Controls how the join code is displayed based on the visibility state.
  // When editing this code, ensure that position does not change so that the
  // text will not jump around when toggling visibility.
  Widget _buildJoinCodeDisplay(
    BuildContext context,
    JoinCodeDisplayModel viewModel,
  ) {
    final display = Text(
      viewModel.joinCode,
      style: ShadTheme.of(context).textTheme.h3,
    );

    if (viewModel.isCodeVisible) {
      return display;
    } else if (viewModel.hideWithoutBlur) {
      return Visibility.maintain(visible: false, child: display);
    } else {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Text(
          viewModel.joinCode,
          style: ShadTheme.of(context).textTheme.h3,
        ),
      );
    }
  }

  @override
  JoinCodeDisplayModel viewModelBuilder(BuildContext context) =>
      JoinCodeDisplayModel(joinCode: _joinCode);
}
