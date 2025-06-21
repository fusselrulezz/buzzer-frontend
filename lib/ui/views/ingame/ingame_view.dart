import 'package:buzzer/model/game_context.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import 'ingame_view.desktop.dart';
import 'ingame_view.tablet.dart';
import 'ingame_view.mobile.dart';
import 'ingame_viewmodel.dart';

class IngameView extends StackedView<IngameViewModel> {
  final GameContext gameContext;

  const IngameView({
    super.key,
    required this.gameContext,
  });

  @override
  Widget builder(
    BuildContext context,
    IngameViewModel viewModel,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const IngameViewMobile(),
      tablet: (_) => const IngameViewTablet(),
      desktop: (_) => const IngameViewDesktop(),
    );
  }

  @override
  IngameViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      IngameViewModel(gameContext: gameContext);
}
