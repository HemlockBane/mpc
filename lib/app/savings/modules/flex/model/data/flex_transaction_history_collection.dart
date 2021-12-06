import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flex_transaction_history_collection.g.dart';

@JsonSerializable()
class FlexTransactionHistoryCollection extends DataCollection<FlexTransaction> {
  FlexTransactionHistoryCollection();
  factory FlexTransactionHistoryCollection.fromJson(Object? data) => _$FlexTransactionHistoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FlexTransactionHistoryCollectionToJson(this);
}