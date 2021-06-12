import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:moniepoint_flutter/core/models/history_item.dart';

part 'transfer_history_item.g.dart';

@JsonSerializable()
class TransferHistoryItem extends HistoryItem {

  @JsonKey(name:"sinkAccountName")
  final String? sinkAccountName;

  @JsonKey(name:"validatedSinkAccountName")
  final String? validatedSinkAccountName;

  @JsonKey(name:"nameEnquiryReference")
  final String? nameEnquiryReference;

  @JsonKey(name:"transactionId")
  final String? transactionId;

  @JsonKey(name:"sourceAccountProviderCode")
  final String? sourceAccountProviderCode;

  @JsonKey(name:"sinkAccountProviderCode")
  final String? sinkAccountProviderCode;

  @JsonKey(name:"sinkAccountProviderName")
  final String? sinkAccountProviderName;

  @JsonKey(name:"sourceAccountProviderName")
  final String? sourceAccountProviderName;

  @JsonKey(name:"sourceAccountNumber")
  final String? sourceAccountNumber;

  @JsonKey(name:"sinkAccountNumber")
  final String? sinkAccountNumber;

  @JsonKey(name:"minorFeeAmount")
  final double? minorFeeAmount;

  @JsonKey(name:"minorVatAmount")
  final double? minorVatAmount;

  @JsonKey(name:"narration")
  final String? narration;

  @JsonKey(name:"extraInformation")
  final String? extraInformation;

  @JsonKey(name:"currencyCode")
  final String? currencyCode;

  @JsonKey(name:"timeAdded")
  final String? dateCreated;

  @JsonKey(name:"timeExecuted")
  @TypeConverters([ListIntConverter])
  final String? timeExecuted;

  @JsonKey(name:"transferBatchKey")
  final String? transferBatchKey;

  @JsonKey(name:"transferType")
  final String? transferType;

  @JsonKey(name:"dateAdded")
  final int? dateAdded;

  TransferHistoryItem({
    this.sinkAccountName,
    this.validatedSinkAccountName,
    this.nameEnquiryReference,
    this.transactionId,
    this.sourceAccountProviderCode,
    this.sinkAccountProviderCode,
    this.sinkAccountProviderName,
    this.sourceAccountProviderName,
    this.sourceAccountNumber,
    this.sinkAccountNumber,
    this.minorFeeAmount,
    this.minorVatAmount,
    this.narration,
    this.extraInformation,
    this.currencyCode,
    this.dateCreated,
    this.timeExecuted,
    this.transferBatchKey,
    this.transferType,
    this.dateAdded
  });

  factory TransferHistoryItem.fromJson(Object? data) => _$TransferHistoryItemFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferHistoryItemToJson(this);

}