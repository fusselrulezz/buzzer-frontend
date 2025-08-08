import "package:buzzer/mvvm/view_model_widget.dart";
import "package:buzzer/ui/routes/license/license_screen_model.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

/// The mobile variant of the license screen.
class LicenseScreenMobile extends ViewModelWidget<LicenseScreenModel> {
  /// Creates a new [LicenseScreenMobile] widget.
  const LicenseScreenMobile({super.key});

  @override
  Widget build(BuildContext context, LicenseScreenModel viewModel) {
    return const Placeholder();
  }
}
