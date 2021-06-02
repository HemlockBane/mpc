// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_service_provider_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimeServiceProviderItem _$AirtimeServiceProviderItemFromJson(
    Map<String, dynamic> json) {
  return AirtimeServiceProviderItem(
    id: json['id'] as int,
    active: json['active'] as bool?,
    amount: json['amount'] as int?,
    code: json['code'] as String?,
    currencySymbol: json['currencySymbol'] as String?,
    fee: (json['fee'] as num?)?.toDouble(),
    name: json['name'] as String?,
    paymentCode: json['paymentCode'] as String?,
    priceFixed: json['priceFixed'] as bool?,
    billerId: json['billerId'] as String?,
  );
}

Map<String, dynamic> _$AirtimeServiceProviderItemToJson(
        AirtimeServiceProviderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'active': instance.active,
      'amount': instance.amount,
      'code': instance.code,
      'currencySymbol': instance.currencySymbol,
      'fee': instance.fee,
      'name': instance.name,
      'paymentCode': instance.paymentCode,
      'priceFixed': instance.priceFixed,
      'billerId': instance.billerId,
    };
