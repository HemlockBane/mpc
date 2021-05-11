// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountUpdate _$AccountUpdateFromJson(Map<String, dynamic> json) {
  return AccountUpdate(
    customerDetailInfo: json['customerDetailInfo'] == null
        ? null
        : CustomerDetailInfo.fromJson(json['customerDetailInfo'] as Object),
    nextOfKinInfo: json['nextOfKinInfo'] == null
        ? null
        : NextOfKinInfo.fromJson(json['nextOfKinInfo'] as Object),
    mailingAddressInfo: json['mailingAddressInfo'] == null
        ? null
        : AddressInfo.fromJson(json['mailingAddressInfo'] as Object),
    identificationInfo: json['customerIdentificationInfo'] == null
        ? null
        : CustomerIdentificationInfo.fromJson(
            json['customerIdentificationInfo'] as Object),
  );
}

Map<String, dynamic> _$AccountUpdateToJson(AccountUpdate instance) =>
    <String, dynamic>{
      'customerDetailInfo': instance.customerDetailInfo,
      'nextOfKinInfo': instance.nextOfKinInfo,
      'mailingAddressInfo': instance.mailingAddressInfo,
      'customerIdentificationInfo': instance.identificationInfo,
    };
