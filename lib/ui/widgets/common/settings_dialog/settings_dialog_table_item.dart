import "package:shadcn_flutter/shadcn_flutter.dart";

/// Represents an item in the settings dialog table.
class SettingsDialogTableItem {
  /// The label for the item, displayed in the first column.
  final String label;

  /// A builder function that returns a widget for the second column.
  final Widget Function(BuildContext context) builder;

  /// Creates a new [SettingsDialogTableItem].
  const SettingsDialogTableItem({required this.label, required this.builder});

  /// Creates a new [SettingsDialogTableItem] for selecting an item from a list
  /// of possible values which are provided by the [items] parameter.
  static SettingsDialogTableItem select<T>({
    required String label,
    required T value,
    required String Function(T value) displayName,
    required void Function(BuildContext context, T? value) onChanged,
    required List<T> items,
  }) {
    final itemButtons = items
        .map((e) => SelectItemButton(value: e, child: Text(displayName(e))))
        .toList();

    return SettingsDialogTableItem(
      label: label,
      builder: (context) => Select<T>(
        value: value,
        itemBuilder: (_, value) => Text(displayName(value)),
        onChanged: (value) => onChanged(context, value),
        popup: (context) {
          return SelectPopup<T>(items: SelectItemList(children: itemButtons));
        },
      ),
    );
  }
}
