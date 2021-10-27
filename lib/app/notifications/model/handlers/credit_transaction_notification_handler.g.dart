// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_transaction_notification_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditTransactionMessage _$CreditTransactionMessageFromJson(
    Map<String, dynamic> json) {
  return CreditTransactionMessage(
    transactionObj: json['transactionObj'] == null
        ? null
        : AccountTransaction.fromJson(json['transactionObj'] as Object),
  );
}

Map<String, dynamic> _$CreditTransactionMessageToJson(
        CreditTransactionMessage instance) =>
    <String, dynamic>{
      'transactionObj': instance.transactionObj,
    };
