// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debit_transaction_notification_handler.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebitTransactionMessage _$DebitTransactionMessageFromJson(
    Map<String, dynamic> json) {
  return DebitTransactionMessage(
    transactionObj: json['transactionObj'] == null
        ? null
        : AccountTransaction.fromJson(json['transactionObj'] as Object),
  );
}

Map<String, dynamic> _$DebitTransactionMessageToJson(
        DebitTransactionMessage instance) =>
    <String, dynamic>{
      'transactionObj': instance.transactionObj,
    };
