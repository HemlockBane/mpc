// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ussd_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

USSDConfiguration _$USSDConfigurationFromJson(Map<String, dynamic> json) {
  return USSDConfiguration()
    ..id = json['id'] as int?
    ..baseCode = json['baseCode'] == null
        ? null
        : BaseCode.fromJson(json['baseCode'] as Object)
    ..body = json['body'] as String?
    ..name = json['name'] as String?
    ..description = json['description'] as String?
    ..preview = json['preview'] as String?;
}

Map<String, dynamic> _$USSDConfigurationToJson(USSDConfiguration instance) =>
    <String, dynamic>{
      'id': instance.id,
      'baseCode': instance.baseCode,
      'body': instance.body,
      'name': instance.name,
      'description': instance.description,
      'preview': instance.preview,
    };

BaseCode _$BaseCodeFromJson(Map<String, dynamic> json) {
  return BaseCode()
    ..id = json['id'] as int?
    ..baseCode = json['baseCode'] as String?;
}

Map<String, dynamic> _$BaseCodeToJson(BaseCode instance) => <String, dynamic>{
      'id': instance.id,
      'baseCode': instance.baseCode,
    };
