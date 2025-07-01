import "package:auto_route/auto_route.dart";
import "package:logger/logger.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/app_router.gr.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/model/game_context.dart";
import "package:buzzer/model/identity.dart";
import "package:buzzer/mvvm/base_view_model.dart";
import "package:buzzer/services/api_service.dart";
import "package:buzzer/services/authentication_service.dart";
import "package:buzzer/services/buzzer_service.dart";
import "package:buzzer_client/buzzer_client.dart";

class CreateRoomFormModel extends BaseViewModel {
  final Logger _logger = getLogger("CreateRoomFormModel");

  final TextEditingController _roomNameController = TextEditingController();

  TextEditingController get roomNameController => _roomNameController;

  final TextEditingController _userNameController = TextEditingController();

  TextEditingController get userNameController => _userNameController;

  bool get isRoomNameValid => roomNameController.text.isNotEmpty;

  bool get isUsernameValid => userNameController.text.isNotEmpty;

  bool get isFormValid => isRoomNameValid && isUsernameValid;

  void disposeForm() {
    _roomNameController.dispose();
    _userNameController.dispose();
  }

  Future<void> onPressedCreateRoom(BuildContext context) async {
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

    final roomName = roomNameController.text.trim();
    final userName = userNameController.text.trim();

    if (roomName.isEmpty || userName.isEmpty) {
      setError("Please provide both room name and user name.");
      setBusy(false);
      return;
    }

    var createRequest = GameRoomCreateRequest(
      name: roomName,
      playerName: userName,
    );

    try {
      var response = await locator<ApiService>().client.apiGameRoomCreatePost(
        body: createRequest,
      );

      var result = response.body;

      if (!response.isSuccessful || result == null) {
        setError(response.error);
        _logger.e("Failed to create room: ${response.error}");
        return;
      }

      if (context.mounted) {
        await _onSuccessfullyCreatedRoom(context, result);
      }
    } catch (e) {
      setError(e);
      _logger.e("Failed to create room", error: e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _onSuccessfullyCreatedRoom(
    BuildContext context,
    GameRoomCreateResponseDto response,
  ) async {
    _logger.i("Room created successfully: ${response.gameRoom.id}");

    locator<AuthenticationService>().authenticate(
      Identity(
        accessToken: response.token,
        refreshToken: response.refreshToken,
      ),
    );

    await locator<BuzzerService>().connect();

    if (context.mounted) {
      context.router.push(
        IngameRoute(
          gameContext: GameContext(
            roomId: response.gameRoom.id,
            roomName: response.gameRoom.name,
            userId: response.player.id,
            userName: response.player.name,
            joinCode: response.joinCode,
            isHost: response.player.isHost,
          ),
        ),
      );
    }
  }
}
