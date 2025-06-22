import 'package:buzzer/model/game_context.dart';
import 'package:buzzer_client/buzzer_client.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'player_list_model.dart';

class PlayerList extends StackedView<PlayerListModel> {
  final GameContext gameContext;

  const PlayerList({
    super.key,
    required this.gameContext,
  });

  @override
  Widget builder(
    BuildContext context,
    PlayerListModel viewModel,
    Widget? child,
  ) {
    final data = viewModel.data;

    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final players = viewModel.data as Playerlist;

    return SizedBox(
      width: 300,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: players.players.length,
        itemBuilder: (context, index) {
          return _buildListTile(context, players.players[index]);
        },
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    GameRoomPlayerListDto player,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(player.name).bold,
      subtitle: Text(player.id).muted.small,
    );
  }

  @override
  PlayerListModel viewModelBuilder(
    BuildContext context,
  ) =>
      PlayerListModel(gameContext: gameContext);
}
