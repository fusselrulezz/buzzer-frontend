import "package:buzzer/app/app_logger.dart";
import "package:buzzer/mvvm/base_view_models.dart";
import "package:easy_localization/easy_localization.dart";
import "package:flutter/services.dart";
import "package:logger/logger.dart";
import "package:shadcn_flutter/shadcn_flutter.dart";

/// Displays a join code for a game room, allowing users to copy it to the
/// clipboard or toggle its visibility.
class JoinCodeDisplayModel extends BaseViewModel {
  /// The translation key prefix for this widget.
  static const trPrefix = "widgets.join_code_display";

  final Logger _logger = getLogger("JoinCodeDisplayModel");

  /// The join code to be displayed.
  final String joinCode;

  bool _isCodeVisible = true;

  /// Whether the join code is currently visible.
  bool get isCodeVisible => _isCodeVisible;

  /// Indicates whether the join code should be hidden without blurring the
  /// text. This is useful for saving performance.
  // TODO: Make this configurable in the UI, or detect based on client type.
  bool get hideWithoutBlur => false;

  /// Creates a new [JoinCodeDisplayModel] instance.
  JoinCodeDisplayModel({required this.joinCode});

  /// Will be called when the user has pressed the "Copy" button
  /// to copy the join code to the clipboard.
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
      builder: (context) =>
          Card(child: Text("$trPrefix.copy.copied".tr()).medium),
    );
  }

  void _showCopyFailurePopover(BuildContext context) {
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      overlayBarrier: OverlayBarrier(
        borderRadius: Theme.of(context).borderRadiusLg,
      ),
      builder: (context) =>
          Card(child: Text("$trPrefix.copy.not_copied".tr()).medium),
    );
  }

  /// Will be called when the user has pressed the "Toggle Visibility" button
  /// to toggle the visibility of the join code.
  void onPressedToggleVisibility() {
    _isCodeVisible = !_isCodeVisible;
    rebuildUi();
    _logger.i("Join code visibility toggled: $_isCodeVisible");
  }
}
