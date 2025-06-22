import 'package:json_annotation/json_annotation.dart';

part 'system_config.g.dart';

@JsonSerializable()
class SystemConfig {
  final String serviceUrl;

  SystemConfig({
    required this.serviceUrl,
  });

  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);

  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}
