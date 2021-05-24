// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_vat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeeVat _$FeeVatFromJson(Map<String, dynamic> json) {
  return FeeVat(
    minorAmount: json['minorAmount'] as int?,
    minorFee: json['minorFee'] as int?,
    minorVat: json['minorVat'] as int?,
    sourceBankCode: json['sourceBankCode'] as String?,
    sinkBankCode: json['sinkBankCode'] as String?,
  );
}

Map<String, dynamic> _$FeeVatToJson(FeeVat instance) => <String, dynamic>{
      'minorAmount': instance.minorAmount,
      'minorFee': instance.minorFee,
      'minorVat': instance.minorVat,
      'sourceBankCode': instance.sourceBankCode,
      'sinkBankCode': instance.sinkBankCode,
    };
