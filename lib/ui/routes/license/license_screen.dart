import "package:auto_route/auto_route.dart";
import "package:responsive_builder2/responsive_builder2.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/mvvm/mvvm_view.dart";

import "license_screen.desktop.dart";
import "license_screen.mobile.dart";
import "license_screen_model.dart";

/// A screen that displays the licenses of the application and its dependencies.
/// This screen is typically used to inform users about the open-source licenses
/// of the libraries and frameworks used in the application.
@RoutePage()
class LicenseScreen extends MvvmView<LicenseScreenModel> {
  /// The translation prefix for the license screen.
  static const trPrefix = "routes.license";

  /// Creates a new [LicenseScreen] widget.
  const LicenseScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    LicenseScreenModel viewModel,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder2(
      desktop: (_, _) => const LicenseScreenDesktop(),
      phone: (_, __) => const LicenseScreenMobile(),
    );
  }

  @override
  LicenseScreenModel viewModelBuilder(BuildContext context) =>
      LicenseScreenModel();
}
