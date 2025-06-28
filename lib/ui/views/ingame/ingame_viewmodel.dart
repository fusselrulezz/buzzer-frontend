import 'dart:async';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/helper/managed_stream_subscriptions.dart';
import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/services/authentication_service.dart';
import 'package:buzzer/services/buzzer_service.dart';

class IngameViewModel extends BaseViewModel with ManagedStreamSubscriptions {
  final GameContext gameContext;

  final BuzzerService _buzzerService = locator<BuzzerService>();

  final RouterService _routerService = locator<RouterService>();

  IngameViewModel({
    required this.gameContext,
  }) {
    addSubscriptions([
      _buzzerService.buzzedStream.listen(_onPlayerBuzzed),
      _buzzerService.buzzerClearedStream.listen(_onBuzzerCleared),
      _buzzerService.playerConnectedStream.listen(_onPlayerConnected),
      _buzzerService.playerDisconnectedStream.listen(_onPlayerDisconnected),
    ]);
  }

  String get roomName => gameContext.roomName;

  String get userName => gameContext.userName;

  String get joinCode => gameContext.joinCode;

  bool get isHost => gameContext.isHost;

  bool _buzzerEnabled = true;

  bool get buzzerEnabled => _buzzerEnabled;

  bool get resetButtonEnabled => !_buzzerEnabled;

  @override
  Future<void> dispose() async {
    await disposeSubscriptions();
    super.dispose();
  }

  Future<void> onPressedLeaveRoom() async {
    locator<AuthenticationService>().clearIdentity();
    _buzzerService.disconnect();
    _routerService.pop();
  }

  Future<void> onPressedBuzzer() async {
    if (!_buzzerEnabled) {
      return;
    }

    await _buzzerService.buzz(gameContext.roomId, gameContext.userId);

    rebuildUi();
  }

  Future<void> _onPlayerBuzzed(String playerId) async {
    _buzzerEnabled = false;
    rebuildUi();
  }

  void _onBuzzerCleared(String event) {
    _buzzerEnabled = true;
    rebuildUi();
  }

  void _onPlayerConnected(String playerId) {}

  void _onPlayerDisconnected(String playerId) {}

  Future<void> onPressedResetBuzzer() async {
    if (!resetButtonEnabled) {
      return;
    }

    await _buzzerService.clearBuzzer(gameContext.roomId);
  }
}
