import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';

import 'account_update_flag.dart';

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

  Map<String, bool> getRequiredFieldMappings() {
    return {
      Flags.ADDITIONAL_INFO: additionalInfo ?? false,
      Flags.IDENTIFICATION_INFO: identificationInfo ?? false,
      Flags.IDENTIFICATION_PROOF: identificationProof ?? false,
      Flags.IDENTIFICATION_VERIFIED: identificationVerified ?? false,
      Flags.ADDRESS_INFO: addressInfo ?? false,
      Flags.ADDRESS_PROOF: addressProof ?? false,
      Flags.ADDRESS_VERIFIED: addressVerified ?? false,
      Flags.NEXT_OF_KIN_INFO: nextOfKinInfo ?? false,
      Flags.BVN_VERIFIED: bvnVerified ?? false,
    };
  }

  List<AccountUpdateFlag> toAccountUpdateFlag() {
  //if the account status is null let's fallback to the customer update flags
  //this means we cannot ascertain if the account is on pnd but definitely means that some
  //records are still required from the user, so we good
  final accountStatus = UserInstance().accountStatus;
  final customer = UserInstance().getUser()?.customers?.first;

  final flags = accountStatus?.listFlags() ?? customer?.listFlags();

  final map = getRequiredFieldMappings();

  return flags?.where((element) => element != null )
      .map((e) => e!.copyWith(required: map[e.flagName] ?? false))
      .toList() ?? [];
  }
}
