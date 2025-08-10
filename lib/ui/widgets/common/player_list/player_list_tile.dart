import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:flutter/material.dart";

import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer_client/buzzer_client.dart";
import "package:shadcn_ui/shadcn_ui.dart";

/// A widget that displays a player's information in a list tile format.
class PlayerListTile extends StatelessWidget {
  /// The player data to be displayed in the list tile.
  final PlayerDto player;

  /// Indicates whether the player's buzzer is active.
  /// If `true`, the buzzer is active; if `false`, it is inactive
  final bool buzzerActive;

  /// Creates a new [PlayerListTile] widget.
  const PlayerListTile({
    super.key,
    required this.player,
    required this.buzzerActive,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      title: Row(
        children: [
          Icon(
            BootstrapIcons.circle_fill,
            color: buzzerActive ? Colors.red : Colors.grey,
            size: 16.0,
          ),
          horizontalSpaceSmall,
          Text(player.name, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      // TODO: Make sure this is "small" too.
      subtitle: Text(player.id, style: ShadTheme.of(context).textTheme.small),
    );
  }
}
