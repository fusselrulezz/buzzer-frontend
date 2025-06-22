import 'package:buzzer/ui/common/ui_helpers.dart';
import 'package:flutter/material.dart' show ListTile;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:buzzer/model/game_context.dart';
import 'package:buzzer/model/player.dart';
import 'package:buzzer/model/playerlist.dart';

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
    const maxWidth = 300.0;

    final data = viewModel.data;

    if (data == null) {
      return const SizedBox(
        width: maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            verticalSpaceSmall,
            Text("Loading players..."),
          ],
        ),
      );
    }

    final players = viewModel.data as Playerlist;

    return SizedBox(
      width: maxWidth,
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
    Player player,
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
