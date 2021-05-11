// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
    id: json['id'] as int?,
    code: json['code'] as String?,
    name: json['name'] as String?,
    postCode: json['postCode'] as String?,
    isoCode: json['isoCode'] as String?,
    base64Icon: json['base64Icon'] as String?,
    active: json['active'] as bool?,
    states: json['states'] as List<dynamic>?,
  );
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'postCode': instance.postCode,
      'isoCode': instance.isoCode,
      'base64Icon': instance.base64Icon,
      'active': instance.active,
      'states': instance.states,
    };
