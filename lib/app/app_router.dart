import "package:auto_route/auto_route.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/guards/auth_guard.dart";

/// The main router for the Buzzer app.
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Home page, containing a screen to create or join a game
    AutoRoute(page: HomeRoute.page, initial: true, path: "/"),

    // Ingame page, containing the game screen
    AutoRoute(page: IngameRoute.page, guards: [AuthGuard()], path: "/ingame"),

    // License page
    AutoRoute(page: LicenseRoute.page, path: "/license"),
  ];
}
