import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'account_transaction.dart';

part 'transaction_history_collection.g.dart';

@JsonSerializable()
class TransactionHistoryCollection extends DataCollection<AccountTransaction> {
  TransactionHistoryCollection();
  factory TransactionHistoryCollection.fromJson(Object? data) => _$TransactionHistoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransactionHistoryCollectionToJson(this);
}