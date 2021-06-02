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

Map<String, dynamic> _$AccountUpdateToJson(AccountUpdate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('customerDetailInfo', instance.customerDetailInfo);
  writeNotNull('nextOfKinInfo', instance.nextOfKinInfo);
  writeNotNull('mailingAddressInfo', instance.mailingAddressInfo);
  writeNotNull('customerIdentificationInfo', instance.identificationInfo);
  return val;
}
