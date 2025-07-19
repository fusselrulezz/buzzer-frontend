// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoredIdentity _$StoredIdentityFromJson(Map<String, dynamic> json) =>
    StoredIdentity(
      accessToken: json['accessToken'] as String,
      accessTokenExpiresAt: json['accessTokenExpiresAt'] == null
          ? null
          : DateTime.parse(json['accessTokenExpiresAt'] as String),
      refreshToken: json['refreshToken'] as String,
      refreshTokenExpiresAt: json['refreshTokenExpiresAt'] == null
          ? null
          : DateTime.parse(json['refreshTokenExpiresAt'] as String),
    );

Map<String, dynamic> _$StoredIdentityToJson(
  StoredIdentity instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'accessTokenExpiresAt': instance.accessTokenExpiresAt?.toIso8601String(),
  'refreshToken': instance.refreshToken,
  'refreshTokenExpiresAt': instance.refreshTokenExpiresAt?.toIso8601String(),
};
