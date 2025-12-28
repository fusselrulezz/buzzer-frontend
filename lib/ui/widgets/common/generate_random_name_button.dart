import "package:bootstrap_icons/bootstrap_icons.dart";
import "package:flutter/widgets.dart";
import "package:logger/logger.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/app/service_locator.dart";
import "package:buzzer/services/random_name_service.dart";

/// A button widget that generates a random name when pressed, using the
/// [RandomNameService] to obtain a new random name each time it is clicked.
class GenerateRandomNameButton extends StatelessWidget {
  static final Logger _logger = getLogger("GenerateRandomNameButton");

  static final RandomNameService _randomNameService =
      locator<RandomNameService>();

  /// The size of the button.
  final double buttonSize;

  /// The size of the icon inside the button.
  final double iconSize;

  /// The callback function that is called when a new random name is generated.
  final void Function(String name) onNameGenerated;

  /// Creates a new [GenerateRandomNameButton] widget.
  const GenerateRandomNameButton({
    super.key,
    this.buttonSize = 20.0,
    this.iconSize = 16.0,
    required this.onNameGenerated,
  });

  @override
  Widget build(BuildContext context) {
    if (!_randomNameService.hasRandomNames) {
      return const SizedBox.shrink();
    }

    return ShadIconButton.ghost(
      padding: EdgeInsets.zero,
      width: buttonSize,
      height: buttonSize,
      iconSize: iconSize,
      onPressed: _onPressed,
      icon: const Icon(BootstrapIcons.dice_6),
    );
  }

  void _onPressed() {
    final randomName = generateRandomName();

    if (randomName != null && randomName.isNotEmpty) {
      onNameGenerated(randomName);
    }
  }

  /// Will be called when the user has pressed the "Generate Random Name" button.
  /// It generates a random name using the [RandomNameService].
  String? generateRandomName() {
    final service = locator<RandomNameService>();

    if (!service.hasRandomNames) {
      _logger.e("Failed to generate random name: Service has no data");
      return null;
    }

    try {
      return service.getRandomName();
    } catch (e) {
      _logger.e("Failed to generate random name", error: e);
      return null;
    }
  }
}
