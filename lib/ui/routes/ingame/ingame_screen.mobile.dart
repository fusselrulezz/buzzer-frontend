import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/view_model_widget.dart";
import "package:buzzer/ui/routes/ingame/ingame_screen_model.dart";

/// The mobile variant of the ingame screen.
class IngameScreenMobile extends ViewModelWidget<IngameScreenModel> {
  /// Creates a new [IngameScreenMobile] widget.
  const IngameScreenMobile({super.key});

  @override
  Widget build(BuildContext context, IngameScreenModel viewModel) {
    return const Placeholder();
  }
}
