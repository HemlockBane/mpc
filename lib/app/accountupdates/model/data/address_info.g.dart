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
  )..stateId = json['stateId'] as int?;
}

Map<String, dynamic> _$AddressInfoToJson(AddressInfo instance) {
  final val = <String, dynamic>{
    'addressLine': instance.addressLine,
    'addressCity': instance.addressCity,
    'stateId': instance.stateId,
    'addressLocalGovernmentAreaId': instance.addressLocalGovernmentAreaId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('utilityBillUUID', instance.utilityBillUUID);
  return val;
}
