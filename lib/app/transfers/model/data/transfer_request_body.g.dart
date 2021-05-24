// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferRequestBody _$TransferRequestBodyFromJson(Map<String, dynamic> json) {
  return TransferRequestBody(
    authenticationType: _$enumDecodeNullable(
        _$AuthenticationMethodEnumMap, json['authenticationType']),
    pin: json['pin'] as String?,
    beneficiary: json['beneficiary'] as bool?,
    deviceId: json['deviceId'] as String?,
    minorAmount: json['minorAmount'] as int?,
    minorFeeAmount: json['minorFeeAmount'] as int?,
    minorVatAmount: json['minorVatAmount'] as int?,
    name: json['name'] as String?,
    narration: json['narration'] as String?,
    paymentType: _$enumDecode(_$PaymentTypeEnumMap, json['paymentType']),
    sinkAccountNumber: json['sinkAccountNumber'] as String?,
    sinkAccountProviderCode: json['sinkAccountProviderCode'] as String?,
    sinkAccountProviderName: json['sinkAccountProviderName'] as String?,
    sourceAccountNumber: json['sourceAccountNumber'] as String?,
    sourceAccountProviderCode: json['sourceAccountProviderCode'] as String?,
    userCode: json['userCode'] as String?,
    validatedAccountName: json['validatedAccountName'] as String?,
    metaData: json['metaData'] as String?,
  );
}

Map<String, dynamic> _$TransferRequestBodyToJson(
        TransferRequestBody instance) =>
    <String, dynamic>{
      'authenticationType':
          _$AuthenticationMethodEnumMap[instance.authenticationType],
      'pin': instance.pin,
      'beneficiary': instance.beneficiary,
      'deviceId': instance.deviceId,
      'minorAmount': instance.minorAmount,
      'minorFeeAmount': instance.minorFeeAmount,
      'minorVatAmount': instance.minorVatAmount,
      'name': instance.name,
      'narration': instance.narration,
      'paymentType': _$PaymentTypeEnumMap[instance.paymentType],
      'sinkAccountNumber': instance.sinkAccountNumber,
      'sinkAccountProviderCode': instance.sinkAccountProviderCode,
      'sinkAccountProviderName': instance.sinkAccountProviderName,
      'sourceAccountNumber': instance.sourceAccountNumber,
      'sourceAccountProviderCode': instance.sourceAccountProviderCode,
      'userCode': instance.userCode,
      'validatedAccountName': instance.validatedAccountName,
      'metaData': instance.metaData,
    };

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

const _$PaymentTypeEnumMap = {
  PaymentType.ONE_TIME: 'ONE_TIME',
};
