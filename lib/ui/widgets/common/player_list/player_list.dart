import "package:easy_localization/easy_localization.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

import "package:buzzer/ui/common/ui_helpers.dart";
import "package:buzzer_client/buzzer_client.dart";

import "player_list_tile.dart";

class PlayerList extends StatelessWidget {
  final List<PlayerDto> players;

  final double width;

  const PlayerList({super.key, required this.players, this.width = 300.0});

  @override
  Widget build(BuildContext context) {
    const trPrefix = "widgets.player_list";
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$trPrefix.header.title".tr(),
            style: theme.typography.h4.copyWith(fontSize: 20.0),
          ),
          verticalSpaceTiny,
          ListView.builder(
            shrinkWrap: true,
            itemCount: players.length,
            itemBuilder: (context, index) =>
                PlayerListTile(player: players[index]),
          ),
        ],
      ),
    );
  }
}
