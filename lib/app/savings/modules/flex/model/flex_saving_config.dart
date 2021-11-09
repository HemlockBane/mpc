
import 'package:moniepoint_flutter/app/customer/customer_account.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'flex_saving_config.g.dart';

// @Entity(tableName: "savings_products")
@JsonSerializable()
class FlexSavingConfig {
  FlexSavingConfig({
    required this.id,
    this.createdOn,
    this.version,
    this.flexSaveType,
    this.flexSaveMode,
    this.contributionWeekDay,
    this.contributionMonthDay,
    this.duration,
    this.contributionAmount,
    this.contributionAccount,
    this.active,
  });

  final int id;
  @JsonKey(name: "createdOn", fromJson: stringDateTime, toJson: millisToString)
  final int? createdOn;
  final int? version;
  final String? flexSaveType;
  final String? flexSaveMode;
  final String? contributionWeekDay;
  final int? contributionMonthDay;
  final int? duration;
  final int? contributionAmount;
  final CustomerAccount? contributionAccount;
  final bool? active;

  factory FlexSavingConfig.fromJson(Map<String, dynamic> json) => _$FlexSavingConfigFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSavingConfigToJson(this);
}
