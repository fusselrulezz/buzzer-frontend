import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'ingame_viewmodel.dart';

class IngameViewTablet extends ViewModelWidget<IngameViewModel> {
  const IngameViewTablet({super.key});

  @override
  Widget build(BuildContext context, IngameViewModel viewModel) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello, TABLET UI - IngameView!',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
