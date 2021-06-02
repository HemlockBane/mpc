// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemConfiguration _$SystemConfigurationFromJson(Map<String, dynamic> json) {
  return SystemConfiguration(
    id: json['id'] as int?,
    name: json['name'] as String?,
    key: json['key'] as String?,
    value: json['value'] as String?,
    type: json['type'] as String?,
    description: json['description'] as String?,
    createdAt:
        (json['createdAt'] as List<dynamic>?)?.map((e) => e as int).toList(),
    lastModifiedAt: (json['lastModifiedAt'] as List<dynamic>?)
        ?.map((e) => e as int)
        .toList(),
  );
}

Map<String, dynamic> _$SystemConfigurationToJson(
        SystemConfiguration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'key': instance.key,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
      'createdAt': instance.createdAt,
      'lastModifiedAt': instance.lastModifiedAt,
    };
