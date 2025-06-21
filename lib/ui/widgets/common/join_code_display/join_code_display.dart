import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:buzzer/ui/common/ui_helpers.dart';

import 'join_code_display_model.dart';

class JoinCodeDisplay extends StackedView<JoinCodeDisplayModel> {
  final String _joinCode;

  const JoinCodeDisplay({
    super.key,
    required String joinCode,
  }) : _joinCode = joinCode;

  @override
  Widget builder(
    BuildContext context,
    JoinCodeDisplayModel viewModel,
    Widget? child,
  ) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Join code:"),
            horizontalSpaceMedium,
            Text(
              viewModel.joinCode,
            ).h3,
          ],
        ),
      ],
    );
  }

  @override
  JoinCodeDisplayModel viewModelBuilder(
    BuildContext context,
  ) =>
      JoinCodeDisplayModel(joinCode: _joinCode);
}
