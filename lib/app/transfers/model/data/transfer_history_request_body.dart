import 'package:json_annotation/json_annotation.dart';

part 'transfer_history_request_body.g.dart';

@JsonSerializable()
class TransferHistoryRequestBody {
  TransferHistoryRequestBody({
    this.startDate,
    this.endDate,
    this.page = 0,
    this.pageSize = 20,
  });

  int? startDate;
  int? endDate;
  int page = 0;
  int pageSize = 20;

  factory TransferHistoryRequestBody.fromJson(Object? data) => _$TransferHistoryRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferHistoryRequestBodyToJson(this);
}