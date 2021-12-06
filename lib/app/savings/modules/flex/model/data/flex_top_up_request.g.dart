// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_top_up_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexTopUpRequest _$FlexTopUpRequestFromJson(Map<String, dynamic> json) {
  return FlexTopUpRequest(
    amount: json['amount'] as int?,
    sourceAccount: json['sourceAccount'] as String?,
    destinationAccount: json['destinationAccount'] as String?,
  );
}

Map<String, dynamic> _$FlexTopUpRequestToJson(FlexTopUpRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'sourceAccount': instance.sourceAccount,
      'destinationAccount': instance.destinationAccount,
    };
