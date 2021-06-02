import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'airtime_history_collection.g.dart';

@JsonSerializable()
class AirtimeHistoryCollection extends DataCollection<AirtimeTransaction> {
  AirtimeHistoryCollection();
  factory AirtimeHistoryCollection.fromJson(Object? data) => _$AirtimeHistoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeHistoryCollectionToJson(this);
}