
import 'package:moniepoint_flutter/app/customer/customer_account.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

import 'flex_saving_config.dart';

part 'flex_saving_config_request_body.g.dart';


@JsonSerializable()
class FlexSavingConfigRequestBody {
  FlexSavingConfigRequestBody({
    this.flexSaveType,
    this.flexSaveMode,
    this.contributionWeekDay,
    this.contributionMonthDay,
    this.contributionAmount,
    this.customerAccountId,
    this.customerId,
    this.customerFlexSavingId,
    this.name
  });

  final FlexSaveType? flexSaveType;
  final FlexSaveMode? flexSaveMode;
  final String? contributionWeekDay;
  final int? contributionMonthDay;
  final double? contributionAmount;
  final int? customerAccountId;
  final int? customerId;
  final int? customerFlexSavingId;
  final String? name;

  factory FlexSavingConfigRequestBody.fromJson(Map<String, dynamic> json) => _$FlexSavingConfigRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSavingConfigRequestBodyToJson(this);
}
