import 'package:stacked/stacked.dart';

import 'package:buzzer/app/app.locator.dart';
import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/model/player.dart';
import 'package:buzzer/model/playerlist.dart';
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
    bool error = false;

    await Future.delayed(const Duration(seconds: 10));

    while (true) {
      try {
        if (error) {
          await Future.delayed(const Duration(seconds: 1));
        }

        final list = await _fetchPlayerList();

        yield list;

        rebuildUi();

        await Future.delayed(const Duration(seconds: 1));
      } catch (e) {
        error = true;
      }
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
      players: response.body!.players.map(_createPlayer).toList(),
    );
  }

  Player _createPlayer(GameRoomPlayerListDto e) {
    return Player(
      id: e.id,
      name: e.name,
    );
  }
}
