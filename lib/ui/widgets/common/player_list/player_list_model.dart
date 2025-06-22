import 'package:stacked/stacked.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/services/api_service.dart';
import 'package:buzzer_client/buzzer_client.dart';

class PlayerListModel extends StreamViewModel {
  final GameContext gameContext;

  PlayerListModel({
    required this.gameContext,
  });

  @override
  Stream<Playerlist> get stream => _buildStream();

  Stream<Playerlist> _buildStream() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));

      final list = await _fetchPlayerList();

      yield list;

      rebuildUi();
    }
  }

  Future<Playerlist> _fetchPlayerList() async {
    var response = await locator<ApiService>().client.apiGameRoomRoomIdGet(
          roomId: gameContext.roomId,
        );

    if (!response.isSuccessful || response.body == null) {
      return Playerlist(players: []);
    }

    return Playerlist(
      players: response.body!.players,
    );
  }
}

class Playerlist {
  final List<GameRoomPlayerListDto> players;

  Playerlist({
    required this.players,
  });
}
