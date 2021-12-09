// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_top_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexTopUpRequest _$FlexTopUpRequestFromJson(Map<String, dynamic> json) {
  return FlexTopUpRequest(
    amount: (json['amount'] as num?)?.toDouble(),
    flexSavingAccountId: json['flexSavingAccountId'] as int?,
    customerAccountId: json['customerAccountId'] as int?,
  );
}

Map<String, dynamic> _$FlexTopUpRequestToJson(FlexTopUpRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'flexSavingAccountId': instance.flexSavingAccountId,
      'customerAccountId': instance.customerAccountId,
    };
