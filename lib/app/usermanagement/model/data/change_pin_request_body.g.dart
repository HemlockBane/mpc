// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_pin_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePinRequestBody _$ChangePinRequestBodyFromJson(Map<String, dynamic> json) {
  return ChangePinRequestBody()
    ..oldPin = json['oldPin'] as String?
    ..newPin = json['newPin'] as String?;
}

Map<String, dynamic> _$ChangePinRequestBodyToJson(
        ChangePinRequestBody instance) =>
    <String, dynamic>{
      'oldPin': instance.oldPin,
      'newPin': instance.newPin,
    };
