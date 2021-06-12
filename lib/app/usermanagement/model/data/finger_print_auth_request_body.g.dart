// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finger_print_auth_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FingerPrintAuthRequestBody _$FingerPrintAuthRequestBodyFromJson(
    Map<String, dynamic> json) {
  return FingerPrintAuthRequestBody()
    ..deviceId = json['deviceId'] as String?
    ..fingerprintKey = json['fingerprintKey'] as String?;
}

Map<String, dynamic> _$FingerPrintAuthRequestBodyToJson(
        FingerPrintAuthRequestBody instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'fingerprintKey': instance.fingerprintKey,
    };
