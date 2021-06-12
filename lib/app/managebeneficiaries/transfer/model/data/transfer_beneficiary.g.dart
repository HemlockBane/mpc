// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_beneficiary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferBeneficiary _$TransferBeneficiaryFromJson(Map<String, dynamic> json) {
  return TransferBeneficiary(
    id: json['id'] as int?,
    accountName: json['accountName'] as String,
    accountNumber: json['accountNumber'] as String,
    bvn: json['bvn'] as String?,
    nameEnquiryReference: json['nameEnquiryReference'] as String?,
    accountProviderName: json['accountProviderName'] as String?,
    accountProviderCode: json['accountProviderCode'] as String?,
    frequency: json['frequency'] as int?,
    lastUpdated: json['lastUpdated'] as int?,
  );
}

Map<String, dynamic> _$TransferBeneficiaryToJson(
        TransferBeneficiary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountName': instance.accountName,
      'accountNumber': instance.accountNumber,
      'bvn': instance.bvn,
      'nameEnquiryReference': instance.nameEnquiryReference,
      'accountProviderName': instance.accountProviderName,
      'accountProviderCode': instance.accountProviderCode,
      'frequency': instance.frequency,
      'lastUpdated': instance.lastUpdated,
    };
