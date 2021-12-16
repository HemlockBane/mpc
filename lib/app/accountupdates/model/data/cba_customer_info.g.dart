// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cba_customer_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CBACustomerInfo _$CBACustomerInfoFromJson(Map<String, dynamic> json) {
  return CBACustomerInfo(
    title: json['title'] as String?,
    firstName: json['firstName'] as String?,
    middleName: json['middleName'] as String?,
    lastName: json['lastName'] as String?,
    gender: json['gender'] as String?,
    dateOfBirth: json['dateOfBirth'] as String?,
    emailAddress: json['emailAddress'] as String?,
    phoneNumber: json['phoneNumber'] as String?,
    bankVerificationNumber: json['bankVerificationNumber'] as String?,
    countryCode: json['countryCode'] as String?,
    residentialAddress: json['residentialAddress'] as Map<String, dynamic>?,
    mailingAddress: json['mailingAddress'] as Map<String, dynamic>?,
    nextOfKin: json['nextOfKin'] as Map<String, dynamic>?,
    id: json['id'] as int?,
    code: json['code'] as String?,
    status: json['status'] as String?,
    passportRef: json['passportRef'] as String?,
    signatureRef: json['signatureRef'] as String?,
    location: json['location'] as String?,
    nationality: json['nationality'] as String?,
    localGovernmentOfOrigin: json['localGovernmentOfOrigin'] as String?,
    religion: json['religion'] as String?,
    maritalStatus: json['maritalStatus'] as String?,
    motherMaidenName: json['motherMaidenName'] as String?,
    taxIdentificationNumber: json['taxIdentificationNumber'] as String?,
    employmentStatus: json['employmentStatus'] as String?,
    identificationInfo: json['identificationInfo'] as Map<String, dynamic>?,
    spousalInfo: json['spousalInfo'] as Map<String, dynamic>?,
    employmentInfo: json['employmentInfo'] as Map<String, dynamic>?,
    stateOfOrigin: json['stateOfOrigin'] as String?,
  );
}

Map<String, dynamic> _$CBACustomerInfoToJson(CBACustomerInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'emailAddress': instance.emailAddress,
      'phoneNumber': instance.phoneNumber,
      'bankVerificationNumber': instance.bankVerificationNumber,
      'countryCode': instance.countryCode,
      'residentialAddress': instance.residentialAddress,
      'mailingAddress': instance.mailingAddress,
      'nextOfKin': instance.nextOfKin,
      'id': instance.id,
      'code': instance.code,
      'status': instance.status,
      'passportRef': instance.passportRef,
      'signatureRef': instance.signatureRef,
      'location': instance.location,
      'nationality': instance.nationality,
      'localGovernmentOfOrigin': instance.localGovernmentOfOrigin,
      'religion': instance.religion,
      'maritalStatus': instance.maritalStatus,
      'motherMaidenName': instance.motherMaidenName,
      'taxIdentificationNumber': instance.taxIdentificationNumber,
      'employmentStatus': instance.employmentStatus,
      'identificationInfo': instance.identificationInfo,
      'spousalInfo': instance.spousalInfo,
      'employmentInfo': instance.employmentInfo,
      'stateOfOrigin': instance.stateOfOrigin,
    };
