import "package:auto_route/auto_route.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/secure_storage_service.dart";

/// Guard to protect routes that require authentication.
class AuthGuard extends AutoRouteGuard {
  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final authService = locator<AuthenticationService>();

    if (authService.hasIdentity) {
      resolver.next(true);
      return;
    }

    final storage = locator<SecureStorageService>();

    final storedIdentity = await storage.retrieveIdentity();

    if (storedIdentity != null) {
      authService.authenticate(storedIdentity.toIdentity());
      resolver.next(true);
      return;
    }

    resolver.redirectUntil(HomeRoute());
  }
}
