// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    primaryCbaCustomerId: json['primaryCbaCustomerId'] as String?,
    accountProvider: json['accountProvider'] == null
        ? null
        : AccountProvider.fromJson(json['accountProvider'] as Object),
    email: json['email'] as String?,
    mobileNo: json['mobileNo'] as String?,
    active: json['active'] as bool?,
    relationshipManagerUserId: json['relationshipManagerUserId'] as String?,
    relationshipManagerNodeGuid: json['relationshipManagerNodeGuid'] as String?,
    customerAccountUsers: (json['customerAccountUsers'] as List<dynamic>?)
        ?.map((e) => CustomerAccountUsers.fromJson(e as Object))
        .toList(),
    timeAdded: json['timeAdded'] as String?,
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
    passportUUID: json['passportUUID'] as String?,
    reUploadID: json['reuploadID'] as bool?,
    reUploadProofOfAddress: json['reuploadProofOfAddress'] as bool?,
    addressVerified: json['addressVerified'] as bool?,
    bvnVerified: json['bvnVerified'] as bool?,
    identificationVerified: json['identificationVerified'] as bool?,
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'primaryCbaCustomerId': instance.primaryCbaCustomerId,
      'accountProvider': instance.accountProvider,
      'email': instance.email,
      'mobileNo': instance.mobileNo,
      'active': instance.active,
      'relationshipManagerUserId': instance.relationshipManagerUserId,
      'relationshipManagerNodeGuid': instance.relationshipManagerNodeGuid,
      'customerAccountUsers': instance.customerAccountUsers,
      'timeAdded': instance.timeAdded,
      'bvnVerified': instance.bvnVerified,
      'addressVerified': instance.addressVerified,
      'identificationVerified': instance.identificationVerified,
      'reuploadID': instance.reUploadID,
      'reuploadProofOfAddress': instance.reUploadProofOfAddress,
      'passportUUID': instance.passportUUID,
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
