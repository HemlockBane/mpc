// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequestBody _$LoginRequestBodyFromJson(Map<String, dynamic> json) {
  return LoginRequestBody()
    ..authenticationType = _$enumDecodeNullable(
        _$AuthenticationMethodEnumMap, json['authenticationType'])
    ..username = json['username'] as String
    ..deviceId = json['deviceId'] as String?
    ..deviceName = json['deviceName'] as String?
    ..version = json['version'] as String;
}

Map<String, dynamic> _$LoginRequestBodyToJson(LoginRequestBody instance) =>
    <String, dynamic>{
      'authenticationType':
          _$AuthenticationMethodEnumMap[instance.authenticationType],
      'username': instance.username,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'version': instance.version,
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
