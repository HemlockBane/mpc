// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_answer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateAnswerResponse _$ValidateAnswerResponseFromJson(
    Map<String, dynamic> json) {
  return ValidateAnswerResponse(
    userCustomerTypes: (json['userCustomerTypes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    validationKey: json['validationKey'] as String?,
    accessToken: json['accessToken'] as String?,
    livelinessValidationKey: json['livelinessValidationKey'] as String?,
  )
    ..livelinessError = json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>)
    ..faceMatchError = json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ValidateAnswerResponseToJson(
        ValidateAnswerResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
      'userCustomerTypes': instance.userCustomerTypes,
      'validationKey': instance.validationKey,
      'accessToken': instance.accessToken,
      'livelinessValidationKey': instance.livelinessValidationKey,
    };
