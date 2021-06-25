// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_topup_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataTopUpRequest _$DataTopUpRequestFromJson(Map<String, dynamic> json) {
  return DataTopUpRequest(
    phoneNumber: json['customerId'] as String?,
    dataProviderItemCode: json['dataProviderItemCode'] as String?,
    dataProviderName: json['dataProviderName'] as String?,
    minorCreditAmount: (json['minorCreditAmount'] as num?)?.toDouble(),
    name: json['name'] as String?,
    metaData: json['metaDataObj'] == null
        ? null
        : TransactionMetaData.fromJson(json['metaDataObj'] as Object),
  );
}

Map<String, dynamic> _$DataTopUpRequestToJson(DataTopUpRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('customerId', instance.phoneNumber);
  writeNotNull('dataProviderItemCode', instance.dataProviderItemCode);
  writeNotNull('dataProviderName', instance.dataProviderName);
  writeNotNull('minorCreditAmount', instance.minorCreditAmount);
  writeNotNull('name', instance.name);
  writeNotNull('metaDataObj', instance.metaData);
  return val;
}
