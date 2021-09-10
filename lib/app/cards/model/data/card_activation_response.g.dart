// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_activation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardActivationResponse _$CardActivationResponseFromJson(
    Map<String, dynamic> json) {
  return CardActivationResponse()
    ..livelinessError = json['livelinessError'] == null
        ? null
        : LivelinessError.fromJson(
            json['livelinessError'] as Map<String, dynamic>)
    ..faceMatchError = json['faceMatchError'] == null
        ? null
        : ClientError.fromJson(json['faceMatchError'] as Map<String, dynamic>)
    ..message = json['message'] as String?;
}

Map<String, dynamic> _$CardActivationResponseToJson(
        CardActivationResponse instance) =>
    <String, dynamic>{
      'livelinessError': instance.livelinessError,
      'faceMatchError': instance.faceMatchError,
      'message': instance.message,
    };
