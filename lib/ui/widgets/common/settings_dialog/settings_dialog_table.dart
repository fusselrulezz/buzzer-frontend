import "package:flutter/widgets.dart" as widgets;
import "package:shadcn_flutter/shadcn_flutter.dart";

import "settings_dialog_table_item.dart";

/// A table widget for displaying settings in a dialog.
class SettingsDialogTable extends StatelessWidget {
  /// The maximum width of the table.
  final double maxWidth;

  /// The list of items to display in the table.
  final List<SettingsDialogTableItem> items;

  /// Creates a new [SettingsDialogTable] widget.
  const SettingsDialogTable({
    super.key,
    required this.maxWidth,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scaling = theme.scaling;
    final spacing = scaling * 16;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: theme.colorScheme.foreground),
        child: widgets.Table(
          columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
          children: [
            for (int i = 0; i < items.length; i++) ...[
              widgets.TableRow(
                children: [
                  // Label column
                  Padding(
                    padding: EdgeInsets.only(
                      right: 16 * scaling,
                      top: i == 0 ? 0 : spacing,
                    ),
                    child: SizedBox(
                      height: 32 * scaling,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: Text(
                          items[i].label,
                          style: theme.typography.textSmall,
                        ),
                      ),
                    ),
                  ),
                  // Value column
                  Padding(
                    padding: EdgeInsets.only(top: i == 0 ? 0 : spacing),
                    child: Builder(
                      builder: (context) => items[i].builder(context),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
