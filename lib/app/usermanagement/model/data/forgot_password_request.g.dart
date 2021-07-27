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
    ..activationCode = json['activationCode'] as String?
    ..otp = json['otp'] as String?
    ..key = json['key'] as String?
    ..password = json['password'] as String?
    ..securityAnswer = json['securityAnswer'] == null
        ? null
        : SecurityAnswer.fromJson(
            json['securityAnswer'] as Map<String, dynamic>);
}

Map<String, dynamic> _$ForgotPasswordRequestToJson(
        ForgotPasswordRequest instance) =>
    <String, dynamic>{
      'step': _$ForgotPasswordStepEnumMap[instance.step],
      'username': instance.username,
      'accountNumber': instance.accountNumber,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'bvn': instance.bvn,
      'userCode': instance.otpUserCode,
      'activationCode': instance.activationCode,
      'otp': instance.otp,
      'key': instance.key,
      'password': instance.password,
      'securityAnswer': instance.securityAnswer,
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

const _$ForgotPasswordStepEnumMap = {
  ForgotPasswordStep.INITIATE: 'INITIATE',
  ForgotPasswordStep.VALIDATE_SECURITY_ANSWER: 'VALIDATE_SECURITY_ANSWER',
  ForgotPasswordStep.VALIDATE_OTP: 'VALIDATE_OTP',
  ForgotPasswordStep.COMPLETE: 'COMPLETE',
};
