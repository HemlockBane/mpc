
import 'package:moniepoint_flutter/app/customer/customer_account.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'flex_saving_config.g.dart';

enum FlexSaveType {
  AUTOMATIC, MANUAL
}

enum FlexSaveMode {
  MONTHLY, WEEKLY
}

@JsonSerializable()
class FlexSavingConfig {

  FlexSavingConfig({
    required this.id,
    this.name,
    this.createdOn,
    this.version,
    this.flexSaveType,
    this.flexSaveMode,
    this.contributionWeekDay,
    this.contributionMonthDay,
    this.duration,
    this.contributionAmount,
    this.contributionAccount,
    this.customerAccountId,
    this.customerId,
    this.active,
    this.customerFlexSavingId
  });

  @JsonKey(name: "flexSavingConfigId")
  final int id;
  final String? name;
  @JsonKey(name: "createdOn", fromJson: stringDateTime, toJson: millisToString)
  final int? createdOn;
  final int? version;
  final FlexSaveType? flexSaveType;
  final FlexSaveMode? flexSaveMode;
  final String? contributionWeekDay;
  final int? contributionMonthDay;
  final int? duration;
  final double? contributionAmount;
  final CustomerAccount? contributionAccount;
  final int? customerAccountId;
  final int? customerId;
  final bool? active;
  final int? customerFlexSavingId;

  factory FlexSavingConfig.fromJson(Map<String, dynamic> json) {
    final map = json;
    final monthlySavingConfigDTO = json["flexMonthlySavingConfigDTO"];
    final weeklySavingConfigDTO = json["flexWeeklySavingConfigDTO"];
    if(monthlySavingConfigDTO != null) {
      map["contributionMonthDay"] = monthlySavingConfigDTO["contributionMonthDay"];
    }
    if(weeklySavingConfigDTO != null) {
      map["contributionWeekDay"] = weeklySavingConfigDTO["contributionWeekDay"];
    }
    return _$FlexSavingConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FlexSavingConfigToJson(this);

}
