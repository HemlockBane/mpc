// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'security_flag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SecurityFlags _$SecurityFlagsFromJson(Map<String, dynamic> json) {
  return SecurityFlags(
    json['setPassword'] as bool,
    json['changePassword'] as bool,
    json['setTransactionPin'] as bool,
    json['changeTransactionPin'] as bool,
    json['setLoginPin'] as bool,
    json['changeLoginPin'] as bool,
    json['setFingerprint'] as bool,
    json['setSecurityQuestion'] as bool,
    json['showMessage'] as bool,
    json['changeDevice'] as bool,
    json['addDevice'] as bool,
    json['denyAccess'] as bool,
  );
}

Map<String, dynamic> _$SecurityFlagsToJson(SecurityFlags instance) =>
    <String, dynamic>{
      'setPassword': instance.setPassword,
      'changePassword': instance.changePassword,
      'setTransactionPin': instance.setTransactionPin,
      'changeTransactionPin': instance.changeTransactionPin,
      'setLoginPin': instance.setLoginPin,
      'changeLoginPin': instance.changeLoginPin,
      'setFingerprint': instance.setFingerprint,
      'setSecurityQuestion': instance.setSecurityQuestion,
      'showMessage': instance.showMessage,
      'changeDevice': instance.changeDevice,
      'addDevice': instance.addDevice,
      'denyAccess': instance.denyAccess,
    };
