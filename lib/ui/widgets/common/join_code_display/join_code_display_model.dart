import "package:buzzer/app/app_logger.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:flutter/services.dart";
import "package:logger/logger.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

class JoinCodeDisplayModel extends BaseViewModel {
  final Logger _logger = getLogger("JoinCodeDisplayModel");

  final String joinCode;

  bool _isCodeVisible = true;

  bool get isCodeVisible => _isCodeVisible;

  /// Indicates whether the join code should be hidden without blurring the
  /// text. This is useful for saving performance.
  // TODO: Make this configurable in the UI, or detect based on client type.
  bool get hideWithoutBlur => false;

  JoinCodeDisplayModel({required this.joinCode});

  Future<void> onPressedCopy(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: joinCode));

      _logger.i("Successfully copied join code to clipboard.");

      if (context.mounted) {
        _showCopySuccessPopover(context);
      }
    } catch (e, stackTrace) {
      _logger.e(
        "Failed to copy join code to clipboard",
        error: e,
        stackTrace: stackTrace,
      );

      if (context.mounted) {
        _showCopyFailurePopover(context);
      }
    }
  }

  void _showCopySuccessPopover(BuildContext context) {
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      overlayBarrier: OverlayBarrier(
        borderRadius: Theme.of(context).borderRadiusLg,
      ),
      builder: (context) => Card(child: const Text("Copied!").medium),
    );
  }

  void _showCopyFailurePopover(BuildContext context) {
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      overlayBarrier: OverlayBarrier(
        borderRadius: Theme.of(context).borderRadiusLg,
      ),
      builder: (context) => Card(child: const Text("Could not copy :(").medium),
    );
  }

  void onPressedToggleVisibility() {
    _isCodeVisible = !_isCodeVisible;
    rebuildUi();
    _logger.i("Join code visibility toggled: $_isCodeVisible");
  }
}
