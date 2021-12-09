import 'package:json_annotation/json_annotation.dart';

part 'flex_top_up_request.g.dart';

@JsonSerializable()
class FlexTopUpRequest {

  FlexTopUpRequest({
    this.amount,
    this.flexSavingAccountId,
    this.customerAccountId,
  });

  double? amount;
  int? flexSavingAccountId;
  int? customerAccountId;

  factory FlexTopUpRequest.fromJson(Map<String, dynamic> json) => _$FlexTopUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FlexTopUpRequestToJson(this);
}