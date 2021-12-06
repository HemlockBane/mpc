import 'package:json_annotation/json_annotation.dart';

part 'flex_top_up_request.g.dart';

@JsonSerializable()
class FlexTopUpRequest {

  FlexTopUpRequest({
    this.amount,
    this.sourceAccount,
    this.destinationAccount,
  });

  int? amount;
  String? sourceAccount;
  String? destinationAccount;

  factory FlexTopUpRequest.fromJson(Map<String, dynamic> json) => _$FlexTopUpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$FlexTopUpRequestToJson(this);
}