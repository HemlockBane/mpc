import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/custom_flags.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/post_no_debit_info.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/customer/customer.dart';
import 'package:moniepoint_flutter/app/customer/scheme_code.dart';

part 'account_status.g.dart';

@JsonSerializable()
class AccountStatus {
  final String? customerCode;
  final String? accountName;
  final String? bankVerificationNumber;
  final bool? postNoDebit;
  final PostNoDebitInfo? postNoDebitInfo;
  final CustomFlags? customFlags;
  final Tier? pndLiftScheme;
  final Customer? customer;
  final SchemeCode? schemeCode;

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

  AccountStatus({
    this.customerCode,
    this.accountName,
    this.bankVerificationNumber,
    this.postNoDebit,
    this.postNoDebitInfo,
    this.customFlags,
    this.pndLiftScheme,
    this.additionalInfoFlag,
    this.identificationInfoFlag,
    this.identificationProofFlag,
    this.addressInfoFlag,
    this.addressProofFlag,
    this.nextOfKinInfoFlag,
    this.addressVerificationFlag,
    this.identificationVerificationFlag,
    this.bvnVerificationFlag,
    this.customer,
    this.schemeCode
  });

  factory AccountStatus.fromJson(Object? data) => _$AccountStatusFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountStatusToJson(this);

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