// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheme_requirement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SchemeRequirement _$SchemeRequirementFromJson(Map<String, dynamic> json) {
  return SchemeRequirement(
    id: json['id'] as int,
    createdOn: json['createdOn'] as String?,
    lastModifiedOn: json['lastModifiedOn'] as String?,
    signature: json['signature'] as bool?,
    residentialAddress: json['residentialAddress'] as bool?,
    employment: json['employment'] as bool?,
    nextOfKin: json['nextOfKin'] as bool?,
    identification: json['identification'] as bool?,
    spouse: json['spouse'] as bool?,
    verifiedResidentialAddress: json['verifiedResidentialAddress'] as bool?,
    verifiedEmployment: json['verifiedEmployment'] as bool?,
    verifiedIdentification: json['verifiedIdentification'] as bool?,
  );
}

Map<String, dynamic> _$SchemeRequirementToJson(SchemeRequirement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'signature': instance.signature,
      'residentialAddress': instance.residentialAddress,
      'employment': instance.employment,
      'nextOfKin': instance.nextOfKin,
      'identification': instance.identification,
      'spouse': instance.spouse,
      'verifiedResidentialAddress': instance.verifiedResidentialAddress,
      'verifiedEmployment': instance.verifiedEmployment,
      'verifiedIdentification': instance.verifiedIdentification,
    };
