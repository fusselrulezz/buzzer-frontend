import "package:auto_route/auto_route.dart";
import "package:responsive_builder2/responsive_builder2.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";
import "package:buzzer/ui/routes/ingame/ingame_screen_model.dart";

import "ingame_screen.desktop.dart";
import "ingame_screen.mobile.dart";

/// The ingame screen of the application, which displays the current game
/// state, player list, and buzzer functionality.
@RoutePage()
class IngameScreen extends MvvmView<IngameScreenModel> {
  /// Creates a new [IngameScreen] widget.
  const IngameScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    IngameScreenModel viewModel,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder2(
      desktop: (_, _) => const IngameScreenDesktop(),
      phone: (_, __) => const IngameScreenMobile(),
    );
  }

  @override
  IngameScreenModel viewModelBuilder(BuildContext context) =>
      IngameScreenModel();
}
