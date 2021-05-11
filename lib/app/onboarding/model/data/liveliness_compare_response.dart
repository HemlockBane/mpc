import 'package:json_annotation/json_annotation.dart';

part 'liveliness_compare_response.g.dart';


@JsonSerializable()
class LivelinessCompareResponse {
  @JsonKey(name: "reference")
  String? reference;

  @JsonKey(name: "errorMessage")
  String? errorMessage;

  @JsonKey(name: "status")
  String? status;

  LivelinessCompareResponse();

  factory LivelinessCompareResponse.fromJson(Map<String, dynamic> data) => _$LivelinessCompareResponseFromJson(data);
  Map<String, dynamic> toJson() => _$LivelinessCompareResponseToJson(this);
}