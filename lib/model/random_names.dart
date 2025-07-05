import "package:json_annotation/json_annotation.dart";

part "random_names.g.dart";

/// Stores a list of adjectives and nouns used for generating random names.
@JsonSerializable()
class RandomNames {
  /// The list of adjectives to be used.
  final List<String> adjectives;

  /// The list of nouns to be used.
  final List<String> nouns;

  /// Creates a new [RandomNames] instance with the provided adjectives and nouns.
  RandomNames({required this.adjectives, required this.nouns});

  /// Constructs a [RandomNames] instance from a JSON map.
  factory RandomNames.fromJson(Map<String, dynamic> json) =>
      _$RandomNamesFromJson(json);

  /// Tranforms this [RandomNames] instance into a JSON map.
  Map<String, dynamic> toJson() => _$RandomNamesToJson(this);
}
