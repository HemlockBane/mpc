import 'package:json_annotation/json_annotation.dart';

part 'flex_withdrawal_count.g.dart';

@JsonSerializable()
class FlexWithdrawalCount {

  FlexWithdrawalCount({
    this.count,
    this.message
  });

  int? count;
  String? message;

  factory FlexWithdrawalCount.fromJson(Map<String, dynamic> json) => _$FlexWithdrawalCountFromJson(json);

  Map<String, dynamic> toJson() => _$FlexWithdrawalCountToJson(this);

}