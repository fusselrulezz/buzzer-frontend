import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:stacked/stacked.dart';

import 'package:buzzer/app/app.logger.dart';

class JoinCodeDisplayModel extends BaseViewModel {
  final Logger _logger = getLogger((JoinCodeDisplayModel).toString());

  final String joinCode;

  JoinCodeDisplayModel({
    required this.joinCode,
  });

  Future<void> onPressedCopy(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: joinCode));

      _logger.i("Successfully copied join code to clipboard.");

      if (context.mounted) {
        _showCopySuccessPopover(context);
      }
    } catch (e, stackTrace) {
      _logger.e("Failed to copy join code to clipboard", e, stackTrace);

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
      builder: (context) => Card(
        child: const Text('Copied!').medium,
      ),
    );
  }

  void _showCopyFailurePopover(BuildContext context) {
    showPopover(
      context: context,
      alignment: Alignment.topCenter,
      overlayBarrier: OverlayBarrier(
        borderRadius: Theme.of(context).borderRadiusLg,
      ),
      builder: (context) => Card(
        child: const Text('Could not copy :(').medium,
      ),
    );
  }
}
