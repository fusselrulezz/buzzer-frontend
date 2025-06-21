// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_names.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RandomNames _$RandomNamesFromJson(Map<String, dynamic> json) => RandomNames(
      adjectives: (json['adjectives'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      nouns: (json['nouns'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$RandomNamesToJson(RandomNames instance) =>
    <String, dynamic>{
      'adjectives': instance.adjectives,
      'nouns': instance.nouns,
    };
