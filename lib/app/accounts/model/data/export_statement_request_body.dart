
import 'package:json_annotation/json_annotation.dart';

part 'export_statement_request_body.g.dart';

@JsonSerializable()
class ExportStatementRequestBody {
  ExportStatementRequestBody({
    this.customerAccountId,
    this.fileType,
    this.transactionType,
    this.startDate,
    this.endDate,
  });

  int? customerAccountId;
  String? fileType;
  String? transactionType;
  int? startDate;
  int? endDate;

  factory ExportStatementRequestBody.fromJson(Object? data) => _$ExportStatementRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ExportStatementRequestBodyToJson(this);

}
