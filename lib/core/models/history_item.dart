import 'package:json_annotation/json_annotation.dart';

// part 'history_item.g.dart';

// @JsonSerializable()
abstract class HistoryItem {

  @JsonKey(name:"id")
  int? id;

  int? transactionBatchId;

  @JsonKey(name:"minorAmount")
  double? minorAmount;

  @JsonKey(name:"status")
  String? status;

  @JsonKey(name:"transactionStatus")
  String? transactionStatus;

  @JsonKey(name:"dateCreated")
  String? dateCreated;

  @JsonKey(name:"channel")
  String? channel;

  @JsonKey(name:"responseCode")
  String? responseCode;

  @JsonKey(name:"comment")
  String? comment;

  String getRecipient() => "";


// HistoryItem();

  // factory HistoryItem.fromJson(Object? data) => _$HistoryItemFromJson(data as Map<String, dynamic>);
  // Map<String, dynamic> toJson() => _$HistoryItemToJson(this);

}