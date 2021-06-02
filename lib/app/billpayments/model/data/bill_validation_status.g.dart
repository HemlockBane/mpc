// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_validation_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillValidationStatus _$BillValidationStatusFromJson(Map<String, dynamic> json) {
  return BillValidationStatus(
    customerId: json['customerId'] as String?,
    paymentCode: json['paymentCode'] as String?,
    fullName: json['fullName'] as String?,
    responseDescription: json['responseDescription'] as String?,
    validationReference: json['validationReference'] as String?,
    validationData: json['validationData'] == null
        ? null
        : ValidationData.fromJson(json['validationData'] as Object),
    status: json['status'] as String?,
    message: json['message'] as String?,
  );
}

Map<String, dynamic> _$BillValidationStatusToJson(
        BillValidationStatus instance) =>
    <String, dynamic>{
      'customerId': instance.customerId,
      'paymentCode': instance.paymentCode,
      'fullName': instance.fullName,
      'responseDescription': instance.responseDescription,
      'validationReference': instance.validationReference,
      'validationData': instance.validationData,
      'status': instance.status,
      'message': instance.message,
    };

ValidationData _$ValidationDataFromJson(Map<String, dynamic> json) {
  return ValidationData(
    json['customer_name'] as String?,
  );
}

Map<String, dynamic> _$ValidationDataToJson(ValidationData instance) =>
    <String, dynamic>{
      'customer_name': instance.customerName,
    };
