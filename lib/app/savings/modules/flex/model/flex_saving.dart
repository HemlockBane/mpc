

import 'package:moniepoint_flutter/app/customer/customer.dart';

import 'flex_saving_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'flex_saving.g.dart';

// @Entity(tableName: "savings_products")
@JsonSerializable()
class FlexSaving {
  FlexSaving({
    required this.id,
    this.createdOn,
    this.version,
    this.customer,
    this.flexVersion,
    this.cbaAccountNuban,
    this.interestRate,
    this.totalSavings,
    this.totalAccruedInterest,
    this.totalAppliedPenalties,
    this.flexSavingConfig,
  });

  final int id;
  @JsonKey(name: "createdOn", fromJson: stringDateTime, toJson: millisToString)
  final int? createdOn;
  final int? version;
  final Customer? customer;
  final String? flexVersion;
  final String? cbaAccountNuban;
  final int? interestRate;
  final int? totalSavings;
  final int? totalAccruedInterest;
  final int? totalAppliedPenalties;
  final FlexSavingConfig? flexSavingConfig;

  factory FlexSaving.fromJson(Map<String, dynamic> json) => _$FlexSavingFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSavingToJson(this);
}
