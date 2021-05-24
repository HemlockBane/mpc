// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tier _$TierFromJson(Map<String, dynamic> json) {
  return Tier(
    id: json['id'] as int,
    status: json['status'] as String?,
    createdOn: json['createdOn'] as String?,
    lastModifiedOn: json['lastModifiedOn'] as String?,
    code: json['code'] as String?,
    name: json['name'] as String?,
    classification: json['classification'] as String?,
    accountNumberPrefix: json['accountNumberPrefix'] as String?,
    accountNumberLength: json['accountNumberLength'] as int?,
    allowNegativeBalance: json['allowNegativeBalance'] as bool?,
    allowLien: json['allowLien'] as bool?,
    enableInstantBalanceUpdate: json['enableInstantBalanceUpdate'] as bool?,
    maximumCumulativeBalance:
        (json['maximumCumulativeBalance'] as num?)?.toDouble(),
    maximumSingleDebit: (json['maximumSingleDebit'] as num?)?.toDouble(),
    maximumSingleCredit: (json['maximumSingleCredit'] as num?)?.toDouble(),
    maximumDailyDebit: (json['maximumDailyDebit'] as num?)?.toDouble(),
    maximumDailyCredit: (json['maximumDailyCredit'] as num?)?.toDouble(),
    schemeRequirement: json['schemeRequirement'] == null
        ? null
        : SchemeRequirement.fromJson(json['schemeRequirement'] as Object),
    alternateSchemeRequirement: json['alternateSchemeRequirement'] == null
        ? null
        : AlternateSchemeRequirement.fromJson(
            json['alternateSchemeRequirement'] as Object),
    supportsAccountGeneration: json['supportsAccountGeneration'] as bool?,
  );
}

Map<String, dynamic> _$TierToJson(Tier instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'createdOn': instance.createdOn,
      'lastModifiedOn': instance.lastModifiedOn,
      'code': instance.code,
      'name': instance.name,
      'classification': instance.classification,
      'accountNumberPrefix': instance.accountNumberPrefix,
      'accountNumberLength': instance.accountNumberLength,
      'allowNegativeBalance': instance.allowNegativeBalance,
      'allowLien': instance.allowLien,
      'enableInstantBalanceUpdate': instance.enableInstantBalanceUpdate,
      'maximumCumulativeBalance': instance.maximumCumulativeBalance,
      'maximumSingleDebit': instance.maximumSingleDebit,
      'maximumSingleCredit': instance.maximumSingleCredit,
      'maximumDailyDebit': instance.maximumDailyDebit,
      'maximumDailyCredit': instance.maximumDailyCredit,
      'schemeRequirement': instance.schemeRequirement,
      'alternateSchemeRequirement': instance.alternateSchemeRequirement,
      'supportsAccountGeneration': instance.supportsAccountGeneration,
    };
