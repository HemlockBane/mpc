// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_payment_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillPaymentRequestBody _$BillPaymentRequestBodyFromJson(
    Map<String, dynamic> json) {
  return BillPaymentRequestBody()
    ..paymentType = _$enumDecode(_$PaymentTypeEnumMap, json['paymentType'])
    ..sourceAccountProviderCode = json['sourceAccountProviderCode'] as String?
    ..sourceAccountNumber = json['sourceAccountNumber'] as String?
    ..currencyCode = json['currencyCode'] as String?
    ..request = json['request'] == null
        ? null
        : Request.fromJson(json['request'] as Object)
    ..tracked = json['tracked'] as bool?
    ..saveBeneficiary = json['saveBeneficiary'] as bool?
    ..pin = json['pin'] as String?
    ..otp = json['otp'] as String?
    ..fingerprintKey = json['fingerprintKey'] as String?
    ..deviceId = json['deviceId'] as String?
    ..authenticationType = _$enumDecodeNullable(
        _$AuthenticationMethodEnumMap, json['authenticationType']);
}

Map<String, dynamic> _$BillPaymentRequestBodyToJson(
    BillPaymentRequestBody instance) {
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
  writeNotNull('currencyCode', instance.currencyCode);
  writeNotNull('request', instance.request);
  writeNotNull('tracked', instance.tracked);
  writeNotNull('saveBeneficiary', instance.saveBeneficiary);
  writeNotNull('pin', instance.pin);
  writeNotNull('otp', instance.otp);
  writeNotNull('fingerprintKey', instance.fingerprintKey);
  writeNotNull('deviceId', instance.deviceId);
  writeNotNull('authenticationType',
      _$AuthenticationMethodEnumMap[instance.authenticationType]);
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

Request _$RequestFromJson(Map<String, dynamic> json) {
  return Request()
    ..minorCost = json['minorCost'] as String?
    ..customerId = json['customerId'] as String?
    ..billerProductCode = json['billerProductCode'] as String?
    ..customerValidationReference =
        json['customerValidationReference'] as String?
    ..additionalFieldsMap =
        (json['additionalFieldsMap'] as Map<String, dynamic>?)?.map(
      (k, e) => MapEntry(k, e as String),
    )
    ..location = json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Object);
}

Map<String, dynamic> _$RequestToJson(Request instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('minorCost', instance.minorCost);
  writeNotNull('customerId', instance.customerId);
  writeNotNull('billerProductCode', instance.billerProductCode);
  writeNotNull(
      'customerValidationReference', instance.customerValidationReference);
  writeNotNull('additionalFieldsMap', instance.additionalFieldsMap);
  writeNotNull('location', instance.location);
  return val;
}
