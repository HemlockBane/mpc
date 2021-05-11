// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveliness_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivelinessChecks _$LivelinessChecksFromJson(Map<String, dynamic> json) {
  return LivelinessChecks(
    challenges: (json['challenges'] as List<dynamic>?)
        ?.map((e) => Liveliness.fromJson(e as Map<String, dynamic>))
        .toList(),
    generalProblems: (json['generalProblems'] as List<dynamic>?)
        ?.map((e) => Liveliness.fromJson(e as Map<String, dynamic>))
        .toList(),
    profilePictureCriteria: json['profilePictureCriteria'] == null
        ? null
        : Liveliness.fromJson(
            json['profilePictureCriteria'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LivelinessChecksToJson(LivelinessChecks instance) =>
    <String, dynamic>{
      'challenges': instance.challenges,
      'generalProblems': instance.generalProblems,
      'profilePictureCriteria': instance.profilePictureCriteria,
    };

Liveliness _$LivelinessFromJson(Map<String, dynamic> json) {
  return Liveliness(
    name: json['name'] as String?,
    description: json['description'] as String?,
    criteria: Criteria.fromJson(json['criteria'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LivelinessToJson(Liveliness instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'criteria': instance.criteria,
    };

Criteria _$CriteriaFromJson(Map<String, dynamic> json) {
  return Criteria(
    name: json['name'] as String,
    value: json['value'] as bool?,
    pitch: json['pitch'] == null
        ? null
        : PoseValue.fromJson(json['pitch'] as Map<String, dynamic>),
    roll: json['roll'] == null
        ? null
        : PoseValue.fromJson(json['roll'] as Map<String, dynamic>),
    yaw: json['yaw'] == null
        ? null
        : PoseValue.fromJson(json['yaw'] as Map<String, dynamic>),
    confidence: json['confidence'] == null
        ? null
        : PoseValue.fromJson(json['confidence'] as Map<String, dynamic>),
    sharpness: json['sharpness'] == null
        ? null
        : PoseValue.fromJson(json['sharpness'] as Map<String, dynamic>),
    brightness: json['brightness'] == null
        ? null
        : PoseValue.fromJson(json['brightness'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CriteriaToJson(Criteria instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'pitch': instance.pitch,
      'roll': instance.roll,
      'yaw': instance.yaw,
      'confidence': instance.confidence,
      'sharpness': instance.sharpness,
      'brightness': instance.brightness,
    };

PoseValue _$PoseValueFromJson(Map<String, dynamic> json) {
  return PoseValue(
    positive: (json['positive'] as num?)?.toDouble(),
    negative: (json['negative'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$PoseValueToJson(PoseValue instance) => <String, dynamic>{
      'positive': instance.positive,
      'negative': instance.negative,
    };
