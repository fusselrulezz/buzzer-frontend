import "package:auto_route/auto_route.dart";

import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/model/auth/identity.dart";
import "package:buzzer/model/game_context.dart";
import "package:buzzer/services/api_service.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer/services/game_context_service.dart";
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

    final storageService = locator<SecureStorageService>();

    final storedIdentity = await storageService.retrieveIdentity();

    if (storedIdentity != null) {
      final identity = storedIdentity.toIdentity();

      final gameContext = await _retrieveGameContext(authService, identity);

      if (gameContext != null) {
        locator<GameContextService>().setContext(gameContext);
        resolver.next(true);
        return;
      }
    }

    resolver.redirectUntil(HomeRoute());
  }

  Future<GameContext?> _retrieveGameContext(
    AuthenticationService authService,
    Identity identity,
  ) async {
    final roomId = identity.claims.roomId;
    final playerId = identity.claims.playerId;
    final playerName = identity.claims.playerName;
    final isHost = identity.claims.isHost;

    if (roomId == null || playerId == null || playerName == null) {
      return null;
    }

    authService.authenticate(identity);

    final buzzerService = locator<BuzzerService>();
    await buzzerService.connect();

    final roomResponse = await locator<ApiService>().client
        .apiGameRoomRoomIdGet(roomId: identity.claims.roomId);

    if (!roomResponse.isSuccessful || roomResponse.body == null) {
      return null;
    }

    final roomInfo = roomResponse.body!;
    final roomDetails = await buzzerService.client.fetchRoomDetails();

    return GameContext(
      roomId: roomInfo.id,
      roomName: roomInfo.name,
      userId: playerId,
      userName: playerName,
      joinCode: roomInfo.joinCode,
      isHost: isHost,
      initialGameState: InitialGameState.fromDetails(roomDetails),
    );
  }
}
