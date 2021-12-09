import 'package:json_annotation/json_annotation.dart';

part 'flex_free_withdrawal_count_request.g.dart';

@JsonSerializable()
class FlexFreeWithdrawalCountRequest {

  FlexFreeWithdrawalCountRequest({
    required this.flexSavingsAccountId
  });

  final int flexSavingsAccountId;

  factory FlexFreeWithdrawalCountRequest.fromJson(Map<String, dynamic> json) => _$FlexFreeWithdrawalCountRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FlexFreeWithdrawalCountRequestToJson(this);

}