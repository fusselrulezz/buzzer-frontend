import "package:auto_route/auto_route.dart";
import "package:easy_localization/easy_localization.dart";
import "package:logger/logger.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/model/game_context.dart";
import "package:buzzer/model/identity.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:buzzer/services/api_service.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer/services/random_name_service.dart";
import "package:buzzer_client/buzzer_client.dart";

/// The view model for the join room form, managing the state and logic
/// for joining an existing game room.
class JoinRoomFormModel extends BaseViewModel {
  final Logger _logger = getLogger("JoinRoomFormModel");

  final RandomNameService _randomNameService = locator<RandomNameService>();

  final TextEditingController _joinCodeController = TextEditingController();

  /// The controller for the join code input field.
  TextEditingController get joinCodeController => _joinCodeController;

  final TextEditingController _userNameController = TextEditingController();

  /// The controller for the user name input field.
  TextEditingController get userNameController => _userNameController;

  /// Whether the join code is valid.
  bool get isJoinCodeValid => joinCodeController.text.isNotEmpty;

  /// Whether the user name is valid.
  bool get isUsernameValid => userNameController.text.isNotEmpty;

  /// Whether the form is valid, meaning both join code and user name are valid.
  bool get isFormValid => isJoinCodeValid && isUsernameValid;

  /// Whether the random name feature is visible.
  /// This is true if the [RandomNameService] has any random names available.
  bool get isRandomNameFeatureVisible => _randomNameService.hasRandomNames;

  /// Disposes the controllers used in the form.
  void disposeForm() {
    _joinCodeController.dispose();
    _userNameController.dispose();
  }

  /// Will be called when the user has pressed the "Join Room" button.
  Future<void> onPressedJoinRoom(BuildContext context) async {
    if (isBusy) {
      _logger.w("Join room button pressed while busy, ignoring.");
      return;
    }

    setError(null);
    setBusy(true);
    if (!isFormValid) {
      setError("Please fill in all fields correctly.");
      setBusy(false);
      return;
    }
    final joinCode = joinCodeController.text.trim();
    final userName = userNameController.text.trim();

    if (joinCode.isEmpty || userName.isEmpty) {
      setError("Please provide both room name and user name.");
      setBusy(false);
      return;
    }
    var joinRequest = GameRoomJoinRequest(
      joinCode: joinCode,
      playerName: userName,
    );
    try {
      var response = await locator<ApiService>().client.apiGameRoomJoinPost(
        body: joinRequest,
      );
      var result = response.body;
      if (!response.isSuccessful || result == null) {
        setError(response.error);
        _logger.e("Failed to join room: ${response.error}");
        return;
      }

      if (context.mounted) {
        await _onSuccessfullyJoinedRoom(context, result, joinCode);
      }
    } catch (e, stackTrace) {
      // General exception. This might be a network error or something else.
      // Log it as an connection error.

      setError("errors.connection_error".tr());
      _logger.e("Error creating room", error: e, stackTrace: stackTrace);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _onSuccessfullyJoinedRoom(
    BuildContext context,
    GameRoomJoinedResponseDto response,
    String joinCode,
  ) async {
    _logger.i("Room joined successfully: ${response.gameRoom.id}");

    await locator<AuthenticationService>().authenticate(
      Identity.create(
        accessToken: response.token,
        refreshToken: response.refreshToken,
      ),
    );

    final buzzerService = locator<BuzzerService>();

    await buzzerService.connect();

    final roomDetails = await buzzerService.client.fetchRoomDetails();

    if (context.mounted) {
      context.router.push(
        IngameRoute(
          gameContext: GameContext(
            roomId: response.gameRoom.id,
            roomName: response.gameRoom.name,
            userId: response.player.id,
            userName: response.player.name,
            joinCode: joinCode,
            isHost: response.player.isHost,
            initialGameState: InitialGameState.fromDetails(roomDetails),
          ),
        ),
      );
    }
  }

  /// Will be called when the user has pressed the "Generate Random Name" button.
  /// It generates a random name using the [RandomNameService].
  String generateRandomName() {
    if (!_randomNameService.hasRandomNames) {
      _logger.e("Failed to generate random name: Service has no data");
      return "";
    }

    try {
      return _randomNameService.getRandomName();
    } catch (e) {
      _logger.e("Failed to generate random name", error: e);
      return "";
    }
  }
}
