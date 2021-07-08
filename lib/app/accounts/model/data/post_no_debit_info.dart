import 'package:json_annotation/json_annotation.dart';

part 'post_no_debit_info.g.dart';

@JsonSerializable()
class PostNoDebitInfo {
  final String? status;
  final String? postNoDebitReason;
  final String? postNoDebitAction;
  final double? permittedSingleCredit;
  final double? recordedSingleCredit;
  final double? permittedDailyCredit;
  final double? recordedDailyCredit;
  final double? permittedCumulativeBalance;
  final double? recordedCumulativeBalance;

  PostNoDebitInfo({this.status,
    this.postNoDebitReason,
    this.postNoDebitAction,
    this.permittedSingleCredit,
    this.recordedSingleCredit,
    this.permittedDailyCredit,
    this.recordedDailyCredit,
    this.permittedCumulativeBalance,
    this.recordedCumulativeBalance});

  factory PostNoDebitInfo.fromJson(Object? data) => _$PostNoDebitInfoFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$PostNoDebitInfoToJson(this);

}