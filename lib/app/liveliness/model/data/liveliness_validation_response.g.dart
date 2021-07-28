// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liveliness_validation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LivelinessValidationResponse _$LivelinessValidationResponseFromJson(
    Map<String, dynamic> json) {
  return LivelinessValidationResponse()
    ..livelinessError = json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>)
    ..faceMatchError = json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LivelinessValidationResponseToJson(
        LivelinessValidationResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
    };
