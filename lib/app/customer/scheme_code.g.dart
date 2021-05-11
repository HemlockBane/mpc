// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemeCode _$SchemeCodeFromJson(Map<String, dynamic> json) {
  return SchemeCode(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String?,
    code: json['code'] as String?,
    accountProvider: json['accountProvider'] == null
        ? null
        : AccountProvider.fromJson(json['accountProvider'] as Object),
    unsupportedFeatures: (json['unsupportedFeatures'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    customerType: json['customerType'] as String?,
    timeAdded:
        (json['timeAdded'] as List<dynamic>?)?.map((e) => e as int).toList(),
    defaultAccountRole: json['defaultAccountRole'] as String?,
  );
}

Map<String, dynamic> _$SchemeCodeToJson(SchemeCode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'accountProvider': instance.accountProvider,
      'unsupportedFeatures': instance.unsupportedFeatures,
      'customerType': instance.customerType,
      'timeAdded': instance.timeAdded,
      'defaultAccountRole': instance.defaultAccountRole,
    };
