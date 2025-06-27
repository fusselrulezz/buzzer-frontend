import 'package:buzzer/services/buzzer_service.dart';
import 'package:buzzer_client/buzzer_client.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/app/app.logger.dart';
import 'package:buzzer/app/app.router.dart';
import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/model/identity.dart';
import 'package:buzzer/services/api_service.dart';
import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer/services/random_name_service.dart';
import 'package:buzzer/ui/widgets/common/join_room_form/join_room_form.form.dart';

class JoinRoomFormModel extends FormViewModel {
  final Logger _logger = getLogger("JoinRoomFormModel");

  final RouterService _routerService = locator<RouterService>();

  final RandomNameService _randomNameService = locator<RandomNameService>();

  bool get isJoinCodeValid => joinCodeValue?.isNotEmpty ?? false;

  bool get isUsernameValid => userNameValue?.isNotEmpty ?? false;

  bool get isFormValid => isJoinCodeValid && isUsernameValid;

  bool get isRandomNameFeatureVisible => _randomNameService.hasRandomNames;

  Future<void> onPressedJoinRoom() async {
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

    final joinCode = joinCodeValue;
    final userName = userNameValue;

    if (joinCode == null || userName == null) {
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
        _logger.e('Failed to join room: ${response.error}');
        return;
      }

      await _onSuccessfullyJoinedRoom(result, joinCode);
    } catch (e) {
      setError(e);
      _logger.e('Failed to join room', e);
    } finally {
      setBusy(false);
    }
  }

  Future<void> _onSuccessfullyJoinedRoom(
    GameRoomJoinedResponseDto response,
    String joinCode,
  ) async {
    _logger.i('Room joined successfully: ${response.gameRoom.id}');

    locator<AuthenticationService>().authenticate(Identity(
      accessToken: response.token,
      refreshToken: response.refreshToken,
    ));

    await locator<BuzzerService>().connect();

    _routerService.navigateToIngameView(
      gameContext: GameContext(
        roomId: response.gameRoom.id,
        roomName: response.gameRoom.name,
        userId: response.player.id,
        userName: response.player.name,
        joinCode: joinCode,
        isHost: response.player.isHost,
      ),
    );
  }

  String generateRandomName() {
    if (!_randomNameService.hasRandomNames) {
      _logger.e('Failed to generate random name: Service has no data');
      return "";
    }

    try {
      return _randomNameService.getRandomName();
    } catch (e) {
      _logger.e('Failed to generate random name', e);
      return "";
    }
  }
}
