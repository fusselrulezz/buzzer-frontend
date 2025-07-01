import "package:auto_route/auto_route.dart";
import "package:buzzer/app/app_router.gr.dart";

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Home page, containing a screen to create or join a game
    AutoRoute(page: HomeRoute.page, initial: true),

    // Ingame page, containing the game screen
    AutoRoute(page: IngameRoute.page),
  ];
}
