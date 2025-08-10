//import "package:shadcn_flutter/shadcn_flutter.dart";
//
///// A [InputFeature] that generates a random name when pressed.
//class RandomNameInputFeature extends InputFeature {
//  /// The position of the feature in the input field, either leading or trailing.
//  final InputFeaturePosition position;
//
//  /// An optional icon to display in the input field.
//  final Widget? icon;
//
//  /// A function that generates a random name when called.
//  final String Function() generateName;
//
//  /// Creates a new [RandomNameInputFeature] instance.
//  const RandomNameInputFeature({
//    super.visibility,
//    this.position = InputFeaturePosition.trailing,
//    this.icon,
//    required this.generateName,
//  });
//
//  @override
//  InputFeatureState createState() => _RandomNameInputFeatureState();
//}
//
//class _RandomNameInputFeatureState
//    extends InputFeatureState<RandomNameInputFeature> {
//  Widget _build() {
//    return IconButton.text(
//      icon: feature.icon ?? const Icon(BootstrapIcons.dice6),
//      onPressed: _onPressed,
//      density: ButtonDensity.compact,
//    );
//  }
//
//  void _onPressed() {
//    controller.text = feature.generateName();
//  }
//
//  @override
//  Iterable<Widget> buildTrailing() sync* {
//    if (feature.position == InputFeaturePosition.trailing) {
//      yield _build();
//    }
//  }
//
//  @override
//  Iterable<Widget> buildLeading() sync* {
//    if (feature.position == InputFeaturePosition.leading) {
//      yield _build();
//    }
//  }
//}
