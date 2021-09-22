// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_otp_linking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardOtpLinkingResponse _$CardOtpLinkingResponseFromJson(
    Map<String, dynamic> json) {
  return CardOtpLinkingResponse()
    ..notificationServiceResponseCode =
        json['notificationServiceResponseCode'] as String?
    ..userCode = json['userCode'] as String?;
}

Map<String, dynamic> _$CardOtpLinkingResponseToJson(
        CardOtpLinkingResponse instance) =>
    <String, dynamic>{
      'notificationServiceResponseCode':
          instance.notificationServiceResponseCode,
      'userCode': instance.userCode,
    };
