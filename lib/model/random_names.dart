import "package:json_annotation/json_annotation.dart";

part "random_names.g.dart";

@JsonSerializable()
class RandomNames {
  final List<String> adjectives;

  final List<String> nouns;

  RandomNames({required this.adjectives, required this.nouns});

  factory RandomNames.fromJson(Map<String, dynamic> json) =>
      _$RandomNamesFromJson(json);

  Map<String, dynamic> toJson() => _$RandomNamesToJson(this);
}
