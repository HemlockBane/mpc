// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStatus _$AccountStatusFromJson(Map<String, dynamic> json) {
  return AccountStatus(
    customerCode: json['customerCode'] as String?,
    accountName: json['accountName'] as String?,
    bankVerificationNumber: json['bankVerificationNumber'] as String?,
    postNoDebit: json['postNoDebit'] as bool?,
    postNoDebitInfo: json['postNoDebitInfo'] == null
        ? null
        : PostNoDebitInfo.fromJson(json['postNoDebitInfo'] as Object),
    customFlags: json['customFlags'] == null
        ? null
        : CustomFlags.fromJson(json['customFlags'] as Object),
    pndLiftScheme: json['pndLiftScheme'] == null
        ? null
        : Tier.fromJson(json['pndLiftScheme'] as Object),
    additionalInfoFlag: json['additionalInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['additionalInfoFlag'] as Object),
    identificationInfoFlag: json['identificationInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['identificationInfoFlag'] as Object),
    identificationProofFlag: json['identificationProofFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['identificationProofFlag'] as Object),
    addressInfoFlag: json['addressInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressInfoFlag'] as Object),
    addressProofFlag: json['addressProofFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressProofFlag'] as Object),
    nextOfKinInfoFlag: json['nextOfKinInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['nextOfKinInfoFlag'] as Object),
    addressVerificationFlag: json['addressVerificationFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressVerificationFlag'] as Object),
    identificationVerificationFlag:
        json['identificationVerificationFlag'] == null
            ? null
            : AccountUpdateFlag.fromJson(
                json['identificationVerificationFlag'] as Object),
    bvnVerificationFlag: json['bvnVerificationFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['bvnVerificationFlag'] as Object),
  );
}

Map<String, dynamic> _$AccountStatusToJson(AccountStatus instance) =>
    <String, dynamic>{
      'customerCode': instance.customerCode,
      'accountName': instance.accountName,
      'bankVerificationNumber': instance.bankVerificationNumber,
      'postNoDebit': instance.postNoDebit,
      'postNoDebitInfo': instance.postNoDebitInfo,
      'customFlags': instance.customFlags,
      'pndLiftScheme': instance.pndLiftScheme,
      'additionalInfoFlag': instance.additionalInfoFlag,
      'identificationInfoFlag': instance.identificationInfoFlag,
      'identificationProofFlag': instance.identificationProofFlag,
      'addressInfoFlag': instance.addressInfoFlag,
      'addressProofFlag': instance.addressProofFlag,
      'nextOfKinInfoFlag': instance.nextOfKinInfoFlag,
      'addressVerificationFlag': instance.addressVerificationFlag,
      'identificationVerificationFlag': instance.identificationVerificationFlag,
      'bvnVerificationFlag': instance.bvnVerificationFlag,
    };
