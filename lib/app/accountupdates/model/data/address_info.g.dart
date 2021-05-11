// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressInfo _$AddressInfoFromJson(Map<String, dynamic> json) {
  return AddressInfo(
    addressLine: json['addressLine'] as String?,
    addressCity: json['addressCity'] as String?,
    addressLocalGovernmentAreaId: json['addressLocalGovernmentAreaId'] as int?,
    utilityBillUUID: json['utilityBillUUID'] as String?,
  );
}

Map<String, dynamic> _$AddressInfoToJson(AddressInfo instance) =>
    <String, dynamic>{
      'addressLine': instance.addressLine,
      'addressCity': instance.addressCity,
      'addressLocalGovernmentAreaId': instance.addressLocalGovernmentAreaId,
      'utilityBillUUID': instance.utilityBillUUID,
    };
