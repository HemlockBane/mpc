import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/models/history_item.dart';

import 'biller_product.dart';

part 'bill_history_item.g.dart';

@JsonSerializable()
class BillHistoryItem extends HistoryItem {
  @JsonKey(name:"billerProduct")
  BillerProduct? billProduct;

  @JsonKey(name:"identifier")
  String? identifier;

  BillHistoryItem();

  factory BillHistoryItem.fromJson(Object? data) => _$BillHistoryItemFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillHistoryItemToJson(this);

  @override
  String getRecipient() => "$identifier, ${billProduct?.name}";
}