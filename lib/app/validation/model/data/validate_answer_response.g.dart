// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_answer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateAnswerResponse _$ValidateAnswerResponseFromJson(
    Map<String, dynamic> json) {
  return ValidateAnswerResponse(
    (json['userCustomerTypes'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    SwitchValidationKey.fromJson(json['validationKey'] as Object),
    json['accessToken'] as String?,
  );
}

Map<String, dynamic> _$ValidateAnswerResponseToJson(
        ValidateAnswerResponse instance) =>
    <String, dynamic>{
      'userCustomerTypes': instance.userCustomerTypes,
      'validationKey': instance.validationKey,
      'accessToken': instance.accessToken,
    };
