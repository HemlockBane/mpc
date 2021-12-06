// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flex_saving.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlexSaving _$FlexSavingFromJson(Map<String, dynamic> json) {
  return FlexSaving(
    id: json['customerFlexSavingId'] as int,
    createdOn: stringDateTime(json['createdOn'] as String?),
    customer: json['customer'] == null
        ? null
        : Customer.fromJson(json['customer'] as Object),
    flexVersion: json['flexVersion'] as String?,
    cbaAccountNuban: json['cbaAccountNuban'] as String?,
    flexSavingScheme: json['flexSavingScheme'] == null
        ? null
        : FlexSavingScheme.fromJson(
            json['flexSavingScheme'] as Map<String, dynamic>),
    flexSavingInterestProfile: json['flexSavingInterestProfile'] == null
        ? null
        : FlexSavingInterestProfile.fromJson(
            json['flexSavingInterestProfile'] as Map<String, dynamic>),
    flexSavingConfigId: json['flexSavingConfigId'] as int?,
    configCreated: json['configCreated'] as bool?,
    name: json['name'] as String?,
  )
    ..withdrawalCount = json['withdrawalCount'] == null
        ? null
        : FlexWithdrawalCount.fromJson(
            json['withdrawalCount'] as Map<String, dynamic>)
    ..accountBalance = json['accountBalance'] == null
        ? null
        : AccountBalance.fromJson(json['accountBalance'] as Object);
}

Map<String, dynamic> _$FlexSavingToJson(FlexSaving instance) =>
    <String, dynamic>{
      'customerFlexSavingId': instance.id,
      'createdOn': millisToString(instance.createdOn),
      'customer': instance.customer,
      'flexVersion': instance.flexVersion,
      'cbaAccountNuban': instance.cbaAccountNuban,
      'flexSavingScheme': instance.flexSavingScheme,
      'flexSavingInterestProfile': instance.flexSavingInterestProfile,
      'configCreated': instance.configCreated,
      'flexSavingConfigId': instance.flexSavingConfigId,
      'name': instance.name,
      'withdrawalCount': instance.withdrawalCount,
      'accountBalance': instance.accountBalance,
    };
