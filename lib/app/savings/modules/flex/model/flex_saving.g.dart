// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSaving _$FlexSavingFromJson(Map<String, dynamic> json) {
  return FlexSaving(
    id: json['id'] as int,
    createdOn: stringDateTime(json['createdOn'] as String),
    version: json['version'] as int?,
    customer: json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Object),
    flexVersion: json['flexVersion'] as String?,
    cbaAccountNuban: json['cbaAccountNuban'] as String?,
    interestRate: json['interestRate'] as int?,
    totalSavings: json['totalSavings'] as int?,
    totalAccruedInterest: json['totalAccruedInterest'] as int?,
    totalAppliedPenalties: json['totalAppliedPenalties'] as int?,
    flexSavingConfig: json['flexSavingConfig'] == null
        ? null
        : FlexSavingConfig.fromJson(
            json['flexSavingConfig'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FlexSavingToJson(FlexSaving instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'version': instance.version,
      'customer': instance.customer,
      'flexVersion': instance.flexVersion,
      'cbaAccountNuban': instance.cbaAccountNuban,
      'interestRate': instance.interestRate,
      'totalSavings': instance.totalSavings,
      'totalAccruedInterest': instance.totalAccruedInterest,
      'totalAppliedPenalties': instance.totalAppliedPenalties,
      'flexSavingConfig': instance.flexSavingConfig,
    };
