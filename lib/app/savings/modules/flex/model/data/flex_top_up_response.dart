import 'package:json_annotation/json_annotation.dart';

part 'flex_top_up_response.g.dart';

@JsonSerializable()
class FlexTopUpResponse {

  FlexTopUpResponse({
    this.request
  });

  final FlexTopUpResponse? request;

  factory FlexTopUpResponse.fromJson(Map<String, dynamic> json) => _$FlexTopUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FlexTopUpResponseToJson(this);
}