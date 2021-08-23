import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';

import 'account_provider.dart';
import 'customer_account_user.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final int? id;
  final String? name;
  final String? description;
  final String? primaryCbaCustomerId;
  final AccountProvider? accountProvider;
  final String? email;
  final String? mobileNo;
  final bool? active;
  final String? relationshipManagerUserId;
  final String? relationshipManagerNodeGuid;
  final List<CustomerAccountUsers>? customerAccountUsers;
  final String? timeAdded;
  @JsonKey(name: "passportUUID")
  final String? passportUUID;

  @JsonKey(name:"additionalInfoFlag")
  final AccountUpdateFlag? additionalInfoFlag;

  @JsonKey(name:"identificationInfoFlag")
  final AccountUpdateFlag? identificationInfoFlag;

  @JsonKey(name:"identificationProofFlag")
  final AccountUpdateFlag? identificationProofFlag;

  @JsonKey(name:"addressInfoFlag")
  final AccountUpdateFlag? addressInfoFlag;

  @JsonKey(name:"addressProofFlag")
  final AccountUpdateFlag? addressProofFlag;

  @JsonKey(name:"nextOfKinInfoFlag")
  final AccountUpdateFlag? nextOfKinInfoFlag;

  @JsonKey(name:"addressVerificationFlag")
  final AccountUpdateFlag? addressVerificationFlag;

  @JsonKey(name:"identificationVerificationFlag")
  final AccountUpdateFlag? identificationVerificationFlag;

  @JsonKey(name:"bvnVerificationFlag")
  final AccountUpdateFlag? bvnVerificationFlag;

  // @JsonKey(name:"onboardingStatus")
  // final OnBoardingStatus? onboardingStatus;


  Customer(
      this.id,
      this.name,
      this.description,
      this.primaryCbaCustomerId,
      this.accountProvider,
      this.email,
      this.mobileNo,
      this.active,
      this.relationshipManagerUserId,
      this.relationshipManagerNodeGuid,
      this.customerAccountUsers,
      this.timeAdded,
      this.additionalInfoFlag,
      this.identificationInfoFlag,
      this.identificationProofFlag,
      this.addressInfoFlag,
      this.addressProofFlag,
      this.nextOfKinInfoFlag,
      this.addressVerificationFlag,
      this.identificationVerificationFlag,
      this.bvnVerificationFlag,
      this.passportUUID
      );

  factory Customer.fromJson(Object? data) => _$CustomerFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  List<AccountUpdateFlag?> listFlags() {
    return <AccountUpdateFlag?>[
      additionalInfoFlag?.copyWith(flagName: Flags.ADDITIONAL_INFO),
      identificationInfoFlag?.copyWith(flagName: Flags.IDENTIFICATION_INFO),
      identificationProofFlag?.copyWith(flagName: Flags.IDENTIFICATION_PROOF),
      identificationVerificationFlag?.copyWith(flagName: Flags.IDENTIFICATION_VERIFIED),
      addressInfoFlag?.copyWith(flagName: Flags.ADDRESS_INFO),
      addressProofFlag?.copyWith(flagName: Flags.ADDRESS_PROOF),
      addressVerificationFlag?.copyWith(flagName: Flags.ADDRESS_VERIFIED),
      nextOfKinInfoFlag?.copyWith(flagName: Flags.NEXT_OF_KIN_INFO),
      bvnVerificationFlag?.copyWith(flagName: Flags.BVN_VERIFIED),
    ];
  }
}
