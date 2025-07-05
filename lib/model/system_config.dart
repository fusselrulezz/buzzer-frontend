import "package:json_annotation/json_annotation.dart";

part "system_config.g.dart";

/// Stores the system configuration, such as the service URL.
@JsonSerializable()
class SystemConfig {
  /// The URL of the service that the application connects to.
  final String serviceUrl;

  /// Creates a new [SystemConfig] instance.
  SystemConfig({required this.serviceUrl});

  /// Constructs a [SystemConfig] instance from a JSON map.
  factory SystemConfig.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigFromJson(json);

  /// Transforms this [SystemConfig] instance into a JSON map.
  Map<String, dynamic> toJson() => _$SystemConfigToJson(this);
}
