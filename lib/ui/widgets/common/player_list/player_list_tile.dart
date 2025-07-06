import "package:flutter/material.dart" show ListTile;
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer_client/buzzer_client.dart";

/// A widget that displays a player's information in a list tile format.
class PlayerListTile extends StatelessWidget {
  /// The player data to be displayed in the list tile.
  final PlayerDto player;

  /// Creates a new [PlayerListTile] widget.
  const PlayerListTile({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Text(player.name).bold,
      subtitle: Text(player.id).muted.small,
    );
  }
}
