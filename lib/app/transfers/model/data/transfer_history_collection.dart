import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transfer_history_collection.g.dart';

@JsonSerializable()
class TransferHistoryCollection extends DataCollection<SingleTransferTransaction> {
  TransferHistoryCollection();
  factory TransferHistoryCollection.fromJson(Object? data) => _$TransferHistoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferHistoryCollectionToJson(this);
}