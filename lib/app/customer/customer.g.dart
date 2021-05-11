// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    json['id'] as int?,
    json['name'] as String?,
    json['description'] as String?,
    json['primaryCbaCustomerId'] as String?,
    json['accountProvider'] == null
        ? null
        : AccountProvider.fromJson(json['accountProvider'] as Object),
    json['email'] as String?,
    json['mobileNo'] as String?,
    json['active'] as bool?,
    json['relationshipManagerUserId'] as String?,
    json['relationshipManagerNodeGuid'] as String?,
    (json['customerAccountUsers'] as List<dynamic>?)
        ?.map((e) => CustomerAccountUsers.fromJson(e as Object))
        .toList(),
    (json['timeAdded'] as List<dynamic>?)?.map((e) => e as int).toList(),
    json['additionalInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['additionalInfoFlag'] as Object),
    json['identificationInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['identificationInfoFlag'] as Object),
    json['identificationProofFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['identificationProofFlag'] as Object),
    json['addressInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressInfoFlag'] as Object),
    json['addressProofFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressProofFlag'] as Object),
    json['nextOfKinInfoFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['nextOfKinInfoFlag'] as Object),
    json['addressVerificationFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['addressVerificationFlag'] as Object),
    json['identificationVerificationFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(
            json['identificationVerificationFlag'] as Object),
    json['bvnVerificationFlag'] == null
        ? null
        : AccountUpdateFlag.fromJson(json['bvnVerificationFlag'] as Object),
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
