// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drop_items.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nationality _$NationalityFromJson(Map<String, dynamic> json) {
  return Nationality(
    json['nationality'] as String?,
    json['id'] as int?,
    json['code'] as String?,
    json['name'] as String,
    json['postCode'] as String?,
    json['isoCode'] as String?,
    json['base64Icon'] as String?,
    json['active'] as bool?,
    json['timeAdded'] as String?,
    (json['states'] as List<dynamic>?)
        ?.map((e) => StateOfOrigin.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$NationalityToJson(Nationality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'postCode': instance.postCode,
      'isoCode': instance.isoCode,
      'base64Icon': instance.base64Icon,
      'active': instance.active,
      'timeAdded': instance.timeAdded,
      'states': instance.states,
      'nationality': instance.nationality,
    };

StateOfOrigin _$StateOfOriginFromJson(Map<String, dynamic> json) {
  return StateOfOrigin(
    json['id'] as int?,
    json['name'] as String?,
    json['code'] as String?,
    json['active'] as bool?,
    json['timeAdded'] as String?,
    (json['localGovernmentAreas'] as List<dynamic>?)
        ?.map((e) => LocalGovernmentArea.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StateOfOriginToJson(StateOfOrigin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'active': instance.active,
      'timeAdded': instance.timeAdded,
      'localGovernmentAreas': instance.localGovernmentAreas,
    };

LocalGovernmentArea _$LocalGovernmentAreaFromJson(Map<String, dynamic> json) {
  return LocalGovernmentArea(
    json['id'] as int?,
    json['name'] as String?,
    json['code'] as String?,
    json['active'] as bool?,
    json['timeAdded'] as String?,
  );
}

Map<String, dynamic> _$LocalGovernmentAreaToJson(
        LocalGovernmentArea instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'active': instance.active,
      'timeAdded': instance.timeAdded,
    };
