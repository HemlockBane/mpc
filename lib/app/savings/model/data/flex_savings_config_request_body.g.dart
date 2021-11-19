// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_savings_config_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSetupConfigRequestBody _$FlexSetupConfigRequestBodyFromJson(
    Map<String, dynamic> json) {
  return FlexSetupConfigRequestBody(
    flexSaveType: json['flexSaveType'] as String?,
    flexSaveMode: json['flexSaveMode'] as String?,
    contributionWeekDay: json['contributionWeekDay'] as String?,
    contributionMonthDay: json['contributionMonthDay'] as int?,
    contributionAmount: (json['contributionAmount'] as num?)?.toDouble(),
    customerAccountId: json['customerAccountId'] as int?,
    customerId: json['customerId'] as int?,
    customerFlexSavingId: json['customerFlexSavingId'] as int?,
  );
}

Map<String, dynamic> _$FlexSetupConfigRequestBodyToJson(
        FlexSetupConfigRequestBody instance) =>
    <String, dynamic>{
      'flexSaveType': instance.flexSaveType,
      'flexSaveMode': instance.flexSaveMode,
      'contributionWeekDay': instance.contributionWeekDay,
      'contributionMonthDay': instance.contributionMonthDay,
      'contributionAmount': instance.contributionAmount,
      'customerAccountId': instance.customerAccountId,
      'customerId': instance.customerId,
      'customerFlexSavingId': instance.customerFlexSavingId,
    };
