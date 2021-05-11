// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_no_debit_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostNoDebitInfo _$PostNoDebitInfoFromJson(Map<String, dynamic> json) {
  return PostNoDebitInfo(
    status: json['status'] as String?,
    postNoDebitReason: json['postNoDebitReason'] as String?,
    postNoDebitAction: json['postNoDebitAction'] as String?,
    permittedSingleCredit: json['permittedSingleCredit'] as int?,
    recordedSingleCredit: json['recordedSingleCredit'] as int?,
    permittedDailyCredit: json['permittedDailyCredit'] as int?,
    recordedDailyCredit: json['recordedDailyCredit'] as int?,
    permittedCumulativeBalance: json['permittedCumulativeBalance'] as int?,
    recordedCumulativeBalance:
        (json['recordedCumulativeBalance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$PostNoDebitInfoToJson(PostNoDebitInfo instance) =>
    <String, dynamic>{
      'status': instance.status,
      'postNoDebitReason': instance.postNoDebitReason,
      'postNoDebitAction': instance.postNoDebitAction,
      'permittedSingleCredit': instance.permittedSingleCredit,
      'recordedSingleCredit': instance.recordedSingleCredit,
      'permittedDailyCredit': instance.permittedDailyCredit,
      'recordedDailyCredit': instance.recordedDailyCredit,
      'permittedCumulativeBalance': instance.permittedCumulativeBalance,
      'recordedCumulativeBalance': instance.recordedCumulativeBalance,
    };
