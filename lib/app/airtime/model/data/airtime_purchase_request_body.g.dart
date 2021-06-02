// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'airtime_purchase_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirtimePurchaseRequestBody _$AirtimePurchaseRequestBodyFromJson(
    Map<String, dynamic> json) {
  return AirtimePurchaseRequestBody()
    ..paymentType = _$enumDecode(_$PaymentTypeEnumMap, json['paymentType'])
    ..sourceAccountProviderCode = json['sourceAccountProviderCode'] as String?
    ..sourceAccountNumber = json['sourceAccountNumber'] as String?
    ..tracked = json['tracked'] as bool?
    ..saveBeneficiary = json['saveBeneficiary'] as bool?
    ..airtimeRequest = json['airtimeRequest'] == null
        ? null
        : AirtimeDataRequest.fromJson(json['airtimeRequest'] as Object)
    ..dataTopUpRequest = json['dataTopUpRequest'] == null
        ? null
        : DataTopUpRequest.fromJson(json['dataTopUpRequest'] as Object)
    ..pin = json['pin'] as String?
    ..otp = json['otp'] as String?
    ..fingerprintKey = json['fingerprintKey'] as String?
    ..deviceId = json['deviceId'] as String?
    ..authenticationType = _$enumDecodeNullable(
        _$AuthenticationMethodEnumMap, json['authenticationType'])
    ..userCode = json['userCode'] as String?;
}

Map<String, dynamic> _$AirtimePurchaseRequestBodyToJson(
    AirtimePurchaseRequestBody instance) {
  final val = <String, dynamic>{
    'paymentType': _$PaymentTypeEnumMap[instance.paymentType],
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sourceAccountProviderCode', instance.sourceAccountProviderCode);
  writeNotNull('sourceAccountNumber', instance.sourceAccountNumber);
  writeNotNull('tracked', instance.tracked);
  writeNotNull('saveBeneficiary', instance.saveBeneficiary);
  writeNotNull('airtimeRequest', instance.airtimeRequest);
  writeNotNull('dataTopUpRequest', instance.dataTopUpRequest);
  writeNotNull('pin', instance.pin);
  writeNotNull('otp', instance.otp);
  writeNotNull('fingerprintKey', instance.fingerprintKey);
  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('authenticationType',
      _$AuthenticationMethodEnumMap[instance.authenticationType]);
  writeNotNull('userCode', instance.userCode);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$PaymentTypeEnumMap = {
  PaymentType.ONE_TIME: 'ONE_TIME',
};

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
}

const _$AuthenticationMethodEnumMap = {
  AuthenticationMethod.FINGERPRINT: 'FINGERPRINT',
  AuthenticationMethod.PIN: 'PIN',
  AuthenticationMethod.PASSWORD: 'PASSWORD',
  AuthenticationMethod.OTP: 'OTP',
};
