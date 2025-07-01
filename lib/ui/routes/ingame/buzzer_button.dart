import "package:flutter/material.dart" as mat;
import "package:shadcn_flutter/shadcn_flutter.dart";

class BuzzerButton extends StatelessWidget {
  final double size;

  final double fontSize;

  final bool enabled;

  final void Function()? onPressed;

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
        backgroundColor: Colors.gray,
        foregroundColor: Colors.white,
        elevation: 0,
      );
    }

    String displayText;

    if (enabled) {
      displayText = "BUZZ!";
    } else {
      displayText = "BUZZED";
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
