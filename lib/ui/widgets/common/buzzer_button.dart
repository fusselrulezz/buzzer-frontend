import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart" as mat;
import "package:flutter/material.dart";

/// A button widget that acts as a buzzer, allowing users to press it
/// to signal their readiness or to answer questions in a game.
class BuzzerButton extends StatelessWidget {
  /// The size of the buzzer button, defaulting to 300.0 pixels.
  final double size;

  /// The font size of the text displayed on the buzzer button,
  /// defaulting to 36.0 pixels.
  final double fontSize;

  /// Whether the buzzer button is enabled or disabled.
  /// If enabled, the button will be clickable and styled with a red background.
  /// If disabled, the button will be styled with a gray background
  /// and will not respond to clicks.
  final bool enabled;

  /// The callback function that will be called when the buzzer button is pressed.
  final void Function()? onPressed;

  /// Creates a new [BuzzerButton] widget.
  const BuzzerButton({
    super.key,
    this.size = 300.0,
    this.fontSize = 36.0,
    this.enabled = true,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    mat.ButtonStyle buttonStyle;

    if (enabled) {
      buttonStyle = mat.ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black,
      );
    } else {
      buttonStyle = mat.ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.grey,
        foregroundColor: Colors.white,
        elevation: 0,
      );
    }

    const trPrefix = "widgets.buzzer_button";
    String displayText;

    if (enabled) {
      displayText = "$trPrefix.enabled".tr();
    } else {
      displayText = "$trPrefix.disabled".tr();
    }

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: mat.ElevatedButton(
          style: buttonStyle,
          onPressed: onPressed,
          child: Text(
            displayText,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
