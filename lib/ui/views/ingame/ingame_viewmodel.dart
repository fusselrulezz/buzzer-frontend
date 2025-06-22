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

  Future<void> onPressedLeaveRoom() async {
    _routerService.pop();
  }
}
