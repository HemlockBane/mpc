// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_vat_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeeVatConfig _$FeeVatConfigFromJson(Map<String, dynamic> json) {
  return FeeVatConfig(
    id: json['id'] as int?,
    chargeType: json['chargeType'] as String,
    minorFee: (json['minorFee'] as num?)?.toDouble(),
    minorVat: (json['minorVat'] as num?)?.toDouble(),
    boundedCharges: (json['boundedCharges'] as List<dynamic>?)
        ?.map((e) => BoundedCharges.fromJson(e as Object))
        .toList(),
  );
}

Map<String, dynamic> _$FeeVatConfigToJson(FeeVatConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chargeType': instance.chargeType,
      'minorFee': instance.minorFee,
      'minorVat': instance.minorVat,
      'boundedCharges': instance.boundedCharges,
    };

BoundedCharges _$BoundedChargesFromJson(Map<String, dynamic> json) {
  return BoundedCharges(
    id: json['id'] as int?,
    transactionType: json['transactionType'] as String?,
    feeMinor: json['feeMinor'] as int?,
    vatMinor: json['vatMinor'] as int?,
    lowerLimitMinor: json['lowerLimitMinor'] as int?,
  );
}

Map<String, dynamic> _$BoundedChargesToJson(BoundedCharges instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionType': instance.transactionType,
      'feeMinor': instance.feeMinor,
      'vatMinor': instance.vatMinor,
      'lowerLimitMinor': instance.lowerLimitMinor,
    };
