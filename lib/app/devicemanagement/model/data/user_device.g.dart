// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDevice _$UserDeviceFromJson(Map<String, dynamic> json) {
  return UserDevice(
    id: json['id'] as int,
    name: json['name'] as String?,
    type: json['type'] as String?,
    username: json['username'] as String?,
    deviceId: json['deviceId'] as String,
    fingerprintCipher: json['fingerprintCipher'] as String?,
    imei: json['imei'] as String?,
    clientId: json['clientId'] as String?,
    failedLoginAttempts: json['failedLoginAttempts'] as int?,
    blockReason: json['blockReason'] as String?,
    blockedBy: json['blockedBy'] as String?,
    authorized: json['authorized'] as bool?,
    os: json['os'] as String?,
    model: json['model'] as String?,
    lastLogin: json['lastLogin'] == null
        ? null
        : DateTime.parse(json['lastLogin'] as String),
    dateAdded: json['dateAdded'] == null
        ? null
        : DateTime.parse(json['dateAdded'] as String),
    blocked: json['blocked'] as bool?,
  );
}

Map<String, dynamic> _$UserDeviceToJson(UserDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'username': instance.username,
      'deviceId': instance.deviceId,
      'fingerprintCipher': instance.fingerprintCipher,
      'imei': instance.imei,
      'clientId': instance.clientId,
      'failedLoginAttempts': instance.failedLoginAttempts,
      'blockReason': instance.blockReason,
      'blockedBy': instance.blockedBy,
      'authorized': instance.authorized,
      'os': instance.os,
      'model': instance.model,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'blocked': instance.blocked,
    };
