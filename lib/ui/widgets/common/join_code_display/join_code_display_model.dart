import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class JoinCodeDisplayModel extends BaseViewModel {
  final String joinCode;

  JoinCodeDisplayModel({
    required this.joinCode,
  });

  Future<void> onPressedCopy() async {
    await Clipboard.setData(ClipboardData(text: joinCode));
  }
}
