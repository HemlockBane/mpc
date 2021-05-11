// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_detail_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerDetailInfo _$CustomerDetailInfoFromJson(Map<String, dynamic> json) {
  return CustomerDetailInfo(
    title: json['title'] as String?,
    maritalStatus: json['maritalStatus'] as String?,
    mothersMaidenName: json['mothersMaidenName'] as String?,
    nationality: json['nationality'] as String?,
    religion: json['religion'] as String?,
    localGovernmentAreaOfOriginId:
        json['localGovernmentAreaOfOriginId'] as int?,
    gender: json['gender'] as String?,
    accountOpeningFormRef: json['accountOpeningFormRef'] as String?,
    employmentStatus: json['employmentStatus'] as String?,
    natureOfBusiness: json['natureOfBusiness'] as String?,
    addressInfo: json['addressInfo'] == null
        ? null
        : AddressInfo.fromJson(json['addressInfo'] as Object),
  );
}

Map<String, dynamic> _$CustomerDetailInfoToJson(CustomerDetailInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'maritalStatus': instance.maritalStatus,
      'mothersMaidenName': instance.mothersMaidenName,
      'nationality': instance.nationality,
      'religion': instance.religion,
      'localGovernmentAreaOfOriginId': instance.localGovernmentAreaOfOriginId,
      'gender': instance.gender,
      'accountOpeningFormRef': instance.accountOpeningFormRef,
      'employmentStatus': instance.employmentStatus,
      'natureOfBusiness': instance.natureOfBusiness,
      'addressInfo': instance.addressInfo,
    };
