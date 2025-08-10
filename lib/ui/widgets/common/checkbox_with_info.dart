import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:shadcn_ui/shadcn_ui.dart";

/// A checkbox widget with an info icon that provides additional information
/// when clicked. The checkbox state can be toggled, and the label is displayed
/// next to the checkbox.
class CheckboxWithInfo extends StatefulWidget {
  /// The state of the checkbox, which can be checked or unchecked.
  final bool state;

  /// Callback function that is called when the checkbox state changes.
  final Function(bool) onChanged;

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
  State<CheckboxWithInfo> createState() => _CheckboxWithInfoState();
}

class _CheckboxWithInfoState extends State<CheckboxWithInfo> {
  final popoverController = ShadPopoverController();

  @override
  void dispose() {
    popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ShadCheckbox(
          value: widget.state,
          onChanged: widget.onChanged,
          label: widget.label,
        ),
        ShadPopover(
          controller: popoverController,
          popover: (_) => widget.content,
          child: ShadIconButton.ghost(
            icon: Icon(BootstrapIcons.info_circle),
            onPressed: () {
              popoverController.show();
            },
          ),
        ),
      ],
    );
  }
}
