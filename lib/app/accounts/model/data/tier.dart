import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/alternate_scheme_requirement.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_requirement.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'dart:math';

import 'package:moniepoint_flutter/core/models/user_instance.dart';

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

  bool isQualified() {
    final accountFlags = alternateSchemeRequirement?.toAccountUpdateFlag();
    final sumOfRequiredWeight = accountFlags?.fold(0, (int previousValue, element) {
      return (element.required)
          ? previousValue + element.weight
          : previousValue;
    }) ?? 0;

    final weightOfTotalSupplied = accountFlags?.fold(0, (int previousValue, element) {
      return (element.required && element.status)
          ? previousValue + element.weight
          : previousValue;
    }) ?? 0;

    return (weightOfTotalSupplied > 0) &&
        weightOfTotalSupplied >= sumOfRequiredWeight;
  }

  ///@deprecated
  ///Don't use
  static int getQualifiedTierIndex(List<Tier> tiers) {
    // We put into cognisance that the number of tiers is likely to be more than three
    if (tiers.isEmpty) return 0;

    //Wait a little for the viewPager to layout the items
    final centerTierIndex = tiers.length ~/ 2.abs();
    final centerTier = tiers[centerTierIndex];

    if (centerTier.isQualified()) {
      var lastQualifiedIndex = centerTierIndex;
      //In-case we have more than three tiers,let's get the maximum tier qualified index
      for (var i = centerTierIndex; i <= tiers.length - 1; i++) {
        if (tiers[i].isQualified()) lastQualifiedIndex = i;
      }
      return lastQualifiedIndex;
    } else {
      var lastQualifiedIndex = 0;
      for (var i = centerTierIndex; i >= 0; i--) {
        if (tiers[i].isQualified()) {
          lastQualifiedIndex = i;
          break;
        }
      }
      return lastQualifiedIndex;
    }
  }
}
