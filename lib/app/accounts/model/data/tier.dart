import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/alternate_scheme_requirement.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_requirement.dart';

part 'tier.g.dart';

@JsonSerializable()
class Tier {
  int id;
  final String? status;
  final String? createdOn;
  final String? lastModifiedOn;
  final String? code;
  final String? name;
  final String? classification;
  final String? accountNumberPrefix;
  final int? accountNumberLength;
  final bool? allowNegativeBalance;
  final bool? allowLien;
  final bool? enableInstantBalanceUpdate;
  final int? maximumCumulativeBalance;
  final int? maximumSingleDebit;
  final int? maximumSingleCredit;
  final int? maximumDailyDebit;
  final int? maximumDailyCredit;
  final SchemeRequirement? schemeRequirement;
  @JsonKey(name:"alternateSchemeRequirement")
  final AlternateSchemeRequirement? alternateSchemeRequirement;
  final bool? supportsAccountGeneration;

  Tier(
      {required this.id,
      this.status,
      this.createdOn,
      this.lastModifiedOn,
      this.code,
      this.name,
      this.classification,
      this.accountNumberPrefix,
      this.accountNumberLength,
      this.allowNegativeBalance,
      this.allowLien,
      this.enableInstantBalanceUpdate,
      this.maximumCumulativeBalance,
      this.maximumSingleDebit,
      this.maximumSingleCredit,
      this.maximumDailyDebit,
      this.maximumDailyCredit,
      this.schemeRequirement,
      this.alternateSchemeRequirement,
      this.supportsAccountGeneration});

  factory Tier.fromJson(Object? data) => _$TierFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TierToJson(this);

}
