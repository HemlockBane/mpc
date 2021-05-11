import 'package:json_annotation/json_annotation.dart';

part 'scheme_requirement.g.dart';

@JsonSerializable()
class SchemeRequirement {
  final int id;
  final String? createdOn;
  final String? lastModifiedOn;
  final bool? signature;
  final bool? residentialAddress;
  final bool? employment;
  final bool? nextOfKin;
  final bool? identification;
  final bool? spouse;
  final bool? verifiedResidentialAddress;
  final bool? verifiedEmployment;
  final bool? verifiedIdentification;

  SchemeRequirement({required this.id,
        this.createdOn,
        this.lastModifiedOn,
        this.signature,
        this.residentialAddress,
        this.employment,
        this.nextOfKin,
        this.identification,
        this.spouse,
        this.verifiedResidentialAddress,
        this.verifiedEmployment,
        this.verifiedIdentification});

  factory SchemeRequirement.fromJson(Object? data) => _$SchemeRequirementFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SchemeRequirementToJson(this);

}