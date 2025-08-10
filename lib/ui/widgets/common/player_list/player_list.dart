import "package:easy_localization/easy_localization.dart";

import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer_client/buzzer_client.dart";
import "package:flutter/material.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "player_list_tile.dart";

/// A widget that displays a list of players in a column format.
/// Each player is represented by a [PlayerListTile].
class PlayerList extends StatelessWidget {
  /// The list of players to be displayed in the player list.
  final List<PlayerDto> players;

  /// The width of the player list widget.
  final double width;

  /// The state of the buzzer for each player. This maps whether the buzzer is
  /// enabled or disabled for each player. A value of `true` means the buzzer
  /// is enabled, and `false` means it is disabled.
  final Map<String, bool> playerBuzzerStates;

  /// Creates a new [PlayerList] widget.
  const PlayerList({
    super.key,
    required this.players,
    this.width = 300.0,
    required this.playerBuzzerStates,
  });

  @override
  Widget build(BuildContext context) {
    const trPrefix = "widgets.player_list";
    final theme = ShadTheme.of(context);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$trPrefix.header.title".tr(),
            style: theme.textTheme.h4.copyWith(fontSize: 20.0),
          ),
          verticalSpaceTiny,
          ListView.builder(
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final buzzerActive = playerBuzzerStates[player.id] ?? true;

              return PlayerListTile(player: player, buzzerActive: buzzerActive);
            },
          ),
        ],
      ),
    );
  }
}
