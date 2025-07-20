import "package:auto_route/auto_route.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/services/authentication_service.dart";

/// Guard to protect routes that require authentication.
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authService = locator<AuthenticationService>();

    if (authService.hasIdentity) {
      resolver.next(true);
    } else {
      resolver.redirectUntil(HomeRoute());
    }
  }
}
