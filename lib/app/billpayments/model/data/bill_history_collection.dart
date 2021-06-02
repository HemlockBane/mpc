import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
part 'bill_history_collection.g.dart';

@JsonSerializable()
class BillHistoryCollection extends DataCollection<BillTransaction> {
  BillHistoryCollection();
  factory BillHistoryCollection.fromJson(Object? data) => _$BillHistoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillHistoryCollectionToJson(this);
}