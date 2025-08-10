import "package:flutter/services.dart";
import "package:logger/logger.dart";
import "package:shadcn_ui/shadcn_ui.dart";

import "package:buzzer/app/app_logger.dart";
import "package:buzzer/mvvm/base_view_models.dart";

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

  final ShadPopoverController _popoverController = ShadPopoverController();

  /// The popover controller for the copy success/failure messages.
  ShadPopoverController get popoverController => _popoverController;

  bool _copySuccess = false;

  /// Whether the view should show a copy success message or a failure message.
  bool get copySuccess => _copySuccess;

  /// Creates a new [JoinCodeDisplayModel] instance.
  JoinCodeDisplayModel({required this.joinCode});

  @override
  void dispose() {
    _popoverController.dispose();
    super.dispose();
  }

  /// Will be called when the user has pressed the "Copy" button
  /// to copy the join code to the clipboard.
  Future<void> onPressedCopy() async {
    try {
      await Clipboard.setData(ClipboardData(text: joinCode));

      _logger.i("Successfully copied join code to clipboard.");

      _showCopySuccessPopover();
    } catch (e, stackTrace) {
      _logger.e(
        "Failed to copy join code to clipboard",
        error: e,
        stackTrace: stackTrace,
      );

      _showCopyFailurePopover();
    }
  }

  void _showCopySuccessPopover() {
    _copySuccess = true;
    _popoverController.show();

    // Automatically hide the popover after a short delay.
    Future.delayed(const Duration(seconds: 2), () {
      _popoverController.hide();
    });
  }

  void _showCopyFailurePopover() {
    _copySuccess = false;
    _popoverController.show();

    // Automatically hide the popover after a short delay.
    Future.delayed(const Duration(seconds: 2), () {
      _popoverController.hide();
    });
  }

  /// Will be called when the user has pressed the "Toggle Visibility" button
  /// to toggle the visibility of the join code.
  void onPressedToggleVisibility() {
    _isCodeVisible = !_isCodeVisible;
    rebuildUi();
    _logger.i("Join code visibility toggled: $_isCodeVisible");
  }
}
