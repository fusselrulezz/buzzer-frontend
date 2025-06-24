import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer/services/buzzer_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/model/game_context.dart';

class IngameViewModel extends BaseViewModel {
  final GameContext gameContext;

  final RouterService _routerService = locator<RouterService>();

  IngameViewModel({
    required this.gameContext,
  });

  String get roomName => gameContext.roomName;

  String get userName => gameContext.userName;

  String get joinCode => gameContext.joinCode;

  bool _buzzerEnabled = true;

  bool get buzzerEnabled => _buzzerEnabled;

  Future<void> onPressedLeaveRoom() async {
    locator<AuthenticationService>().clearIdentity();
    await locator<BuzzerService>().disconnect();
    _routerService.pop();
  }

  Future<void> onPressedBuzzer() async {
    _buzzerEnabled = !_buzzerEnabled;

    await locator<BuzzerService>().buzz(gameContext.roomId, gameContext.userId);

    rebuildUi();
  }
}
