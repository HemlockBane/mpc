// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_of_kin_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextOfKinInfo _$NextOfKinInfoFromJson(Map<String, dynamic> json) {
  return NextOfKinInfo(
    nextOfKinFirstName: json['nextOfKinFirstName'] as String?,
    nextOfKinLastName: json['nextOfKinLastName'] as String?,
    nextOfKinMiddleName: json['nextOfKinMiddleName'] as String?,
    nextOfKinRelationship: json['nextOfKinRelationship'] as String?,
    nextOfKinPhoneNumber: json['nextOfKinPhoneNumber'] as String?,
    nextOfKinEmail: json['nextOfKinEmail'] as String?,
    nextOfKinCity: json['nextOfKinCity'] as String?,
    nextOfKinDOB: json['nextOfKinDOB'] as String?,
    addressInfo: json['addressInfo'] == null
        ? null
        : AddressInfo.fromJson(json['addressInfo'] as Object),
  );
}

Map<String, dynamic> _$NextOfKinInfoToJson(NextOfKinInfo instance) =>
    <String, dynamic>{
      'nextOfKinFirstName': instance.nextOfKinFirstName,
      'nextOfKinLastName': instance.nextOfKinLastName,
      'nextOfKinMiddleName': instance.nextOfKinMiddleName,
      'nextOfKinRelationship': instance.nextOfKinRelationship,
      'nextOfKinPhoneNumber': instance.nextOfKinPhoneNumber,
      'nextOfKinEmail': instance.nextOfKinEmail,
      'nextOfKinCity': instance.nextOfKinCity,
      'nextOfKinDOB': instance.nextOfKinDOB,
      'addressInfo': instance.addressInfo,
    };
