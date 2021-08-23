// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_linking_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardLinkingResponse _$CardLinkingResponseFromJson(Map<String, dynamic> json) {
  return CardLinkingResponse()
    ..livelinessError = json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>)
    ..faceMatchError = json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>)
    ..issuanceCode = json['issuanceCode'] as String?;
}

Map<String, dynamic> _$CardLinkingResponseToJson(
        CardLinkingResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
      'issuanceCode': instance.issuanceCode,
    };
