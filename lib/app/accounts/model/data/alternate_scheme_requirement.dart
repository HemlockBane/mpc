import 'package:json_annotation/json_annotation.dart';

part 'alternate_scheme_requirement.g.dart';

@JsonSerializable()
class AlternateSchemeRequirement {
  @JsonKey(name: "additionalInfo")
  final bool? additionalInfo;

  @JsonKey(name: "identificationInfo")
  final bool? identificationInfo;

  @JsonKey(name: "identificationProof")
  final bool? identificationProof;

  @JsonKey(name: "identificationVerified")
  final bool? identificationVerified;

  @JsonKey(name: "addressInfo")
  final bool? addressInfo;

  @JsonKey(name: "addressVerified")
  final bool? addressVerified;

  @JsonKey(name: "addressProof")
  final bool? addressProof;

  @JsonKey(name: "nextOfKinInfo")
  final bool? nextOfKinInfo;

  @JsonKey(name: "employment")
  final bool? employment;

  @JsonKey(name: "employmentVerified")
  final bool? employmentVerified;

  bool? bvnVerified = true;

  @JsonKey(name: "signature")
  final bool? signature;

  AlternateSchemeRequirement(
      this.additionalInfo,
      this.identificationInfo,
      this.identificationProof,
      this.identificationVerified,
      this.addressInfo,
      this.addressVerified,
      this.addressProof,
      this.nextOfKinInfo,
      this.employment,
      this.employmentVerified,
      this.signature);

  factory AlternateSchemeRequirement.fromJson(Object? data) => _$AlternateSchemeRequirementFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AlternateSchemeRequirementToJson(this);

}
