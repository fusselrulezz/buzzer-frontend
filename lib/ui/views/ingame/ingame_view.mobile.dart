import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'ingame_viewmodel.dart';

class IngameViewMobile extends ViewModelWidget<IngameViewModel> {
  const IngameViewMobile({super.key});

  @override
  Widget build(BuildContext context, IngameViewModel viewModel) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello, MOBILE UI - IngameView!',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
