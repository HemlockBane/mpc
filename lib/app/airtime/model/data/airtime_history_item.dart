import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/history_item.dart';

import 'airtime_service_provider.dart';

part 'airtime_history_item.g.dart';

@JsonSerializable()
class AirtimeHistoryItem extends HistoryItem {

  @JsonKey(name:"id")
  int? id;

  @JsonKey(name:"serviceProvider")
  AirtimeServiceProvider? serviceProvider;

  @JsonKey(name:"phoneNumber")
  String? phoneNumber;

  AirtimeHistoryItem();

  factory AirtimeHistoryItem.fromJson(Object? data) => _$AirtimeHistoryItemFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeHistoryItemToJson(this);

  @override
  String getRecipient() => "$phoneNumber, ${serviceProvider?.name}";
}