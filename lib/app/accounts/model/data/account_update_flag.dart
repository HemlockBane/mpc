import 'package:json_annotation/json_annotation.dart';

part 'account_update_flag.g.dart';

@JsonSerializable()
class AccountUpdateFlag {
  final bool status;
  final int weight;

  String? verificationEndTime;
  VerificationState? verificationStates;

  //For internal usage
  @JsonKey(ignore:true)
  String flagName = "";
  //For internal usage
  @JsonKey(ignore:true)
  bool required  = false;

  AccountUpdateFlag(
      this.status,
      this.weight,
      this.verificationEndTime,
      this.verificationStates
      );

  factory AccountUpdateFlag.fromJson(Object? data) => _$AccountUpdateFlagFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountUpdateFlagToJson(this);

  AccountUpdateFlag copyWith({String? flagName, bool? required}) {
    return AccountUpdateFlag(
        status,
        weight,
        verificationEndTime,
        verificationStates
    )..required = required ?? this.required
    ..flagName = flagName ?? this.flagName;
  }

}

enum VerificationState {
PENDING, INPROGRESS, PASSED, FAILED
}

class Flags {
  static const ADDITIONAL_INFO = "additionalInfo";
  static const IDENTIFICATION_INFO = "identificationInfo";
  static const IDENTIFICATION_PROOF = "identificationProof";
  static const IDENTIFICATION_VERIFIED = "identificationVerified";
  static const BVN_VERIFIED = "bvnVerified";
  static const ADDRESS_INFO = "addressInfo";
  static const ADDRESS_PROOF = "addressProof";
  static const ADDRESS_VERIFIED = "addressVerified";
  static const NEXT_OF_KIN_INFO = "nextOfKinInfo";
}