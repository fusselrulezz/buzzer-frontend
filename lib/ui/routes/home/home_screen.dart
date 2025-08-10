import "package:auto_route/auto_route.dart";
import "package:flutter/widgets.dart";
import "package:responsive_builder2/responsive_builder2.dart";

import "home_screen.desktop.dart";
import "home_screen.mobile.dart";

/// The home screen of the application, which serves as the main entry point
/// for users to create or join rooms.
@RoutePage()
class HomeScreen extends StatelessWidget {
  /// The translation key prefix for the home screen.
  static const trPrefix = "routes.home";

  /// Creeates a new [HomeScreen] widget.
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder2(
      desktop: (_, _) => const HomeScreenDesktop(),
      phone: (_, __) => const HomeScreenMobile(),
    );
  }
}
