import 'package:json_annotation/json_annotation.dart';

part 'flex_savings_config_request_body.g.dart';

@JsonSerializable()
class FlexSetupConfigRequestBody {
  FlexSetupConfigRequestBody({
    this.flexSaveType,
    this.flexSaveMode,
    this.contributionWeekDay,
    this.contributionMonthDay,
    this.contributionAmount,
    this.customerAccountId,
    this.customerId,
    this.customerFlexSavingId,
  });

  final String? flexSaveType;
  final String? flexSaveMode;
  final String? contributionWeekDay;
  final int? contributionMonthDay;
  final double? contributionAmount;
  final int? customerAccountId;
  final int? customerId;
  final int? customerFlexSavingId;

  factory FlexSetupConfigRequestBody.fromJson(Map<String, dynamic> json) =>_$FlexSetupConfigRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$FlexSetupConfigRequestBodyToJson(this);
}
