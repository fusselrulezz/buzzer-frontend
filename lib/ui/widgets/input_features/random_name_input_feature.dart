import 'dart:math';

import 'package:shadcn_flutter/shadcn_flutter.dart';

class RandomNameInputFeature extends InputFeature {
  final InputFeaturePosition position;

  final Widget? icon;

  const RandomNameInputFeature({
    super.visibility,
    this.position = InputFeaturePosition.trailing,
    this.icon,
  });

  @override
  InputFeatureState createState() => _RandomNameInputFeatureState();
}

class _RandomNameInputFeatureState
    extends InputFeatureState<RandomNameInputFeature> {
  static const List<String> _nameComponentsFirst = [
    'Super',
    'Mega',
    'Ultra',
    'Hyper',
    'Epic',
    'Legendary',
    'Cosmic',
    'Galactic',
    'Quantum',
    'Mystic',
  ];

  static const List<String> _nameComponentsSecond = [
    'Warrior',
    'Ninja',
    'Wizard',
    'Dragon',
    'Phoenix',
    'Titan',
    'Knight',
    'Samurai',
    'Viking',
    'Rogue',
  ];

  Widget _build() {
    return IconButton.text(
      icon: feature.icon ?? const Icon(BootstrapIcons.dice6),
      onPressed: _onPressed,
      density: ButtonDensity.compact,
    );
  }

  void _onPressed() {
    final random = Random();

    final firstComponent =
        _nameComponentsFirst[random.nextInt(_nameComponentsFirst.length)];
    final secondComponent =
        _nameComponentsSecond[random.nextInt(_nameComponentsSecond.length)];

    controller.text = '$firstComponent$secondComponent';
  }

  @override
  Iterable<Widget> buildTrailing() sync* {
    if (feature.position == InputFeaturePosition.trailing) {
      yield _build();
    }
  }

  @override
  Iterable<Widget> buildLeading() sync* {
    if (feature.position == InputFeaturePosition.leading) {
      yield _build();
    }
  }
}
