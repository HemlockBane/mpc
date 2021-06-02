import 'package:json_annotation/json_annotation.dart';

part 'history_request_body.g.dart';

@JsonSerializable()
class HistoryRequestBody {

  @JsonKey(name:"page")
  int? page;

  @JsonKey(name:"pageSize")
  int? pageSize;
  @JsonKey(name:"startDate")
  int? startDate;
  @JsonKey(name:"endDate")
  int? endDate;
  @JsonKey(name:"statuses")
  List<String>? statuses;

  HistoryRequestBody();

  factory HistoryRequestBody.fromJson(Object? data) => _$HistoryRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$HistoryRequestBodyToJson(this);

  HistoryRequestBody withPage(int page) {
    this.page = page;
    return this;
  }

  HistoryRequestBody withPageSize(int pageSize) {
    this.pageSize = pageSize;
    return this;
  }

  HistoryRequestBody withStartDate(int startDate) {
    this.startDate = startDate;
    return this;
  }

  HistoryRequestBody withEndDate(int endDate) {
    this.endDate = endDate;
    return this;
  }

  HistoryRequestBody withStatuses(List<String> statuses) {
    this.statuses = statuses;
    return this;
  }

}