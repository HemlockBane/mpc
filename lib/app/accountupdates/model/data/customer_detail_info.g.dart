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

Map<String, dynamic> _$CustomerDetailInfoToJson(CustomerDetailInfo instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'maritalStatus': instance.maritalStatus,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('mothersMaidenName', instance.mothersMaidenName);
  val['nationality'] = instance.nationality;
  val['religion'] = instance.religion;
  val['localGovernmentAreaOfOriginId'] = instance.localGovernmentAreaOfOriginId;
  writeNotNull('gender', instance.gender);
  writeNotNull('accountOpeningFormRef', instance.accountOpeningFormRef);
  val['employmentStatus'] = instance.employmentStatus;
  writeNotNull('natureOfBusiness', instance.natureOfBusiness);
  writeNotNull('addressInfo', instance.addressInfo);
  return val;
}