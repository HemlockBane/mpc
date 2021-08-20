// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_request_balance_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardRequestBalanceResponse _$CardRequestBalanceResponseFromJson(
    Map<String, dynamic> json) {
  return CardRequestBalanceResponse()
    ..availableBalance = json['availableBalance'] as String?
    ..cardAmount = json['cardAmount'] as String?
    ..sufficient = json['sufficient'] as bool?;
}

Map<String, dynamic> _$CardRequestBalanceResponseToJson(
        CardRequestBalanceResponse instance) =>
    <String, dynamic>{
      'availableBalance': instance.availableBalance,
      'cardAmount': instance.cardAmount,
      'sufficient': instance.sufficient,
    };
