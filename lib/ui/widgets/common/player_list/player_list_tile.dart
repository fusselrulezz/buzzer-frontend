import "package:flutter/material.dart" show ListTile;
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer_client/buzzer_client.dart";

class PlayerListTile extends StatelessWidget {
  final PlayerDto player;

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
