// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_identification_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerIdentificationInfo _$CustomerIdentificationInfoFromJson(
    Map<String, dynamic> json) {
  return CustomerIdentificationInfo(
    identificationType: json['identificationType'] as String?,
    registrationNumber: json['registrationNumber'] as String?,
    identityIssueDate: json['identityIssueDate'] as String?,
    identityExpiryDate: json['identityExpiryDate'] as String?,
    scannedImageRef: json['scannedImageRef'] as String?,
    uploadedFileName: json['uploadedFileName'] as String?,
  );
}

Map<String, dynamic> _$CustomerIdentificationInfoToJson(
        CustomerIdentificationInfo instance) =>
    <String, dynamic>{
      'identificationType': instance.identificationType,
      'registrationNumber': instance.registrationNumber,
      'identityIssueDate': instance.identityIssueDate,
      'identityExpiryDate': instance.identityExpiryDate,
      'scannedImageRef': instance.scannedImageRef,
      'uploadedFileName': instance.uploadedFileName,
    };
