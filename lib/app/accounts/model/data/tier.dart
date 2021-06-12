import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/alternate_scheme_requirement.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_requirement.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'tier.g.dart';

@Entity(tableName: "tiers", primaryKeys: ["id"])
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
  final double? maximumCumulativeBalance;
  final double? maximumSingleDebit;
  final double? maximumSingleCredit;
  final double? maximumDailyDebit;
  final double? maximumDailyCredit;
  @TypeConverters([SchemeRequirementConverter])
  final SchemeRequirement? schemeRequirement;
  @JsonKey(name:"alternateSchemeRequirement")
  @TypeConverters([AlternateSchemeRequirementConverter])
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
