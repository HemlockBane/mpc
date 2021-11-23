import 'package:json_annotation/json_annotation.dart';

part 'enable_flex_request_body.g.dart';

@JsonSerializable()
class EnableFlexRequestBody {

  EnableFlexRequestBody({
    required this.customerId,
    required this.flexVersion
  });

  final String? customerId;
  final String? flexVersion;

  factory EnableFlexRequestBody.fromJson(Map<String, dynamic> json) =>_$EnableFlexRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EnableFlexRequestBodyToJson(this);
}