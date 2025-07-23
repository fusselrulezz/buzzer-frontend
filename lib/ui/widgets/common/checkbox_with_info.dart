import "package:shadcn_flutter/shadcn_flutter.dart";

/// A checkbox widget with an info icon that provides additional information
/// when clicked. The checkbox state can be toggled, and the label is displayed
/// next to the checkbox.
class CheckboxWithInfo extends StatelessWidget {
  /// The state of the checkbox, which can be checked or unchecked.
  final CheckboxState state;

  /// Callback function that is called when the checkbox state changes.
  final Function(CheckboxState) onChanged;

  /// The label widget that is displayed next to the checkbox.
  final Widget label;

  /// The content displayed in the hover card when the info icon is hovered over.
  /// This can be a longer text that provides more details about the checkbox.
  final Widget content;

  /// Creates a new [CheckboxWithInfo] widget.
  const CheckboxWithInfo({
    super.key,
    required this.state,
    required this.onChanged,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(state: state, onChanged: onChanged, trailing: label.base),
        HoverCard(
          hoverBuilder: (context) {
            return SizedBox(
              width: 300,
              child: SurfaceCard(child: Basic(content: content)),
            );
          },
          child: IconButton.ghost(
            icon: Icon(BootstrapIcons.infoCircle),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
