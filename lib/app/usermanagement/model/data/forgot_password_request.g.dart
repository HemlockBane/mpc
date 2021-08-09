// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forgot_password_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgotPasswordRequest _$ForgotPasswordRequestFromJson(
    Map<String, dynamic> json) {
  return ForgotPasswordRequest()
    ..step = _$enumDecodeNullable(_$ForgotPasswordStepEnumMap, json['step'])
    ..username = json['username'] as String?
    ..accountNumber = json['accountNumber'] as String?
    ..email = json['email'] as String?
    ..phoneNumber = json['phoneNumber'] as String?
    ..bvn = json['bvn'] as String?
    ..otpUserCode = json['userCode'] as String?
    ..otpValidationKey = json['otpValidationKey'] as String?
    ..otp = json['otp'] as String?
    ..key = json['key'] as String?
    ..password = json['password'] as String?
    ..livelinessCheckRef = json['livelinessCheckRef'] as String?
    ..livelinessVerificationFor = _$enumDecodeNullable(
        _$LivelinessVerificationForEnumMap, json['livelinessVerificationFor']);
}

Map<String, dynamic> _$ForgotPasswordRequestToJson(
    ForgotPasswordRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('step', _$ForgotPasswordStepEnumMap[instance.step]);
  writeNotNull('username', instance.username);
  writeNotNull('accountNumber', instance.accountNumber);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('bvn', instance.bvn);
  writeNotNull('userCode', instance.otpUserCode);
  writeNotNull('otpValidationKey', instance.otpValidationKey);
  writeNotNull('otp', instance.otp);
  writeNotNull('key', instance.key);
  writeNotNull('password', instance.password);
  writeNotNull('livelinessCheckRef', instance.livelinessCheckRef);
  writeNotNull('livelinessVerificationFor',
      _$LivelinessVerificationForEnumMap[instance.livelinessVerificationFor]);
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

const _$ForgotPasswordStepEnumMap = {
  ForgotPasswordStep.INITIATE: 'INITIATE',
  ForgotPasswordStep.VALIDATE_SECURITY_ANSWER: 'VALIDATE_SECURITY_ANSWER',
  ForgotPasswordStep.VALIDATE_OTP: 'VALIDATE_OTP',
  ForgotPasswordStep.LIVELINESS_CHECK: 'LIVELINESS_CHECK',
  ForgotPasswordStep.COMPLETE: 'COMPLETE',
};

const _$LivelinessVerificationForEnumMap = {
  LivelinessVerificationFor.ON_BOARDING: 'ON_BOARDING',
  LivelinessVerificationFor.USERNAME_RECOVERY: 'USERNAME_RECOVERY',
  LivelinessVerificationFor.PASSWORD_RECOVERY: 'PASSWORD_RECOVERY',
  LivelinessVerificationFor.REGISTER_DEVICE: 'REGISTER_DEVICE',
};
