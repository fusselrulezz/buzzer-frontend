import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/app/app.router.dart';
import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/services/api_service.dart';
import 'package:buzzer_client/buzzer_client.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'create_room_form.form.dart';

class CreateRoomFormModel extends FormViewModel {
  final Logger _logger = getLogger("CreateRoomFormModel");

  final RouterService _routerService = locator<RouterService>();

  final ApiService _apiService = locator<ApiService>();

  bool get isRoomNameValid => roomNameValue?.isNotEmpty ?? false;

  bool get isUsernameValid => userNameValue?.isNotEmpty ?? false;

  bool get isFormValid => isRoomNameValid && isUsernameValid;

  Future<void> onPressedCreateRoom() async {
    setError(null);

    if (!isFormValid) {
      setError("Please fill in all fields correctly.");
      return;
    }

    final roomName = roomNameValue;
    final userName = userNameValue;

    if (roomName == null || userName == null) {
      setError("Please provide both room name and user name.");
      return;
    }

    setBusy(true);

    var createRequest = GameRoomCreateRequest(
      name: roomName,
      playerName: userName,
    );

    try {
      var response = await _apiService.client.apiGameRoomCreatePost(
        body: createRequest,
      );

      var result = response.body;

      if (!response.isSuccessful || result == null) {
        setError(response.error);
        _logger.e('Failed to create room: ${response.error}');
        return;
      }

      await _onSuccessfullyCreatedRoom(result);
    } catch (e) {
      setError(e);
      _logger.e('Failed to create room', e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _onSuccessfullyCreatedRoom(
    GameRoomCreateResponseDto response,
  ) async {
    _logger.i('Room created successfully: ${response.gameRoom.id}');

    _routerService.navigateToIngameView(
      gameContext: GameContext(
        roomId: response.gameRoom.id,
        roomName: response.gameRoom.name,
        userName: response.playerName,
        joinCode: response.joinCode,
      ),
    );
  }
}
