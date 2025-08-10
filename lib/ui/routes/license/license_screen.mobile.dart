import "package:flutter/material.dart";

import "package:buzzer/mvvm/view_model_widget.dart";

import "license_screen_model.dart";

/// The mobile variant of the license screen.
class LicenseScreenMobile extends ViewModelWidget<LicenseScreenModel> {
  /// Creates a new [LicenseScreenMobile] widget.
  const LicenseScreenMobile({super.key});

  @override
  Widget build(BuildContext context, LicenseScreenModel viewModel) {
    return LicensePage();
  }
}
