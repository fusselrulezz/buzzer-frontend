import 'package:shadcn_flutter/shadcn_flutter.dart';

class RandomNameInputFeature extends InputFeature {
  final InputFeaturePosition position;

  final Widget? icon;

  final String Function() generateName;

  const RandomNameInputFeature({
    super.visibility,
    this.position = InputFeaturePosition.trailing,
    this.icon,
    required this.generateName,
  });

  @override
  InputFeatureState createState() => _RandomNameInputFeatureState();
}

class _RandomNameInputFeatureState
    extends InputFeatureState<RandomNameInputFeature> {
  Widget _build() {
    return IconButton.text(
      icon: feature.icon ?? const Icon(BootstrapIcons.dice6),
      onPressed: _onPressed,
      density: ButtonDensity.compact,
    );
  }

  void _onPressed() {
    controller.text = feature.generateName();
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
