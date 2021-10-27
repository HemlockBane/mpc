// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_transaction_notification_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitCreditTransactionMessage _$DebitCreditTransactionMessageFromJson(
    Map<String, dynamic> json) {
  return DebitCreditTransactionMessage(
    transactionObj: json['transactionObj'] == null
        ? null
        : AccountTransaction.fromJson(json['transactionObj'] as Object),
  );
}

Map<String, dynamic> _$DebitCreditTransactionMessageToJson(
        DebitCreditTransactionMessage instance) =>
    <String, dynamic>{
      'transactionObj': instance.transactionObj,
    };
