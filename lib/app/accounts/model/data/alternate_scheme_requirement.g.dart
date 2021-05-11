// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternate_scheme_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternateSchemeRequirement _$AlternateSchemeRequirementFromJson(
    Map<String, dynamic> json) {
  return AlternateSchemeRequirement(
    json['additionalInfo'] as bool?,
    json['identificationInfo'] as bool?,
    json['identificationProof'] as bool?,
    json['identificationVerified'] as bool?,
    json['addressInfo'] as bool?,
    json['addressVerified'] as bool?,
    json['addressProof'] as bool?,
    json['nextOfKinInfo'] as bool?,
    json['employment'] as bool?,
    json['employmentVerified'] as bool?,
    json['signature'] as bool?,
  )..bvnVerified = json['bvnVerified'] as bool?;
}

Map<String, dynamic> _$AlternateSchemeRequirementToJson(
        AlternateSchemeRequirement instance) =>
    <String, dynamic>{
      'additionalInfo': instance.additionalInfo,
      'identificationInfo': instance.identificationInfo,
      'identificationProof': instance.identificationProof,
      'identificationVerified': instance.identificationVerified,
      'addressInfo': instance.addressInfo,
      'addressVerified': instance.addressVerified,
      'addressProof': instance.addressProof,
      'nextOfKinInfo': instance.nextOfKinInfo,
      'employment': instance.employment,
      'employmentVerified': instance.employmentVerified,
      'bvnVerified': instance.bvnVerified,
      'signature': instance.signature,
    };
