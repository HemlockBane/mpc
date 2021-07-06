// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeviceRequestBody _$UserDeviceRequestBodyFromJson(
    Map<String, dynamic> json) {
  return UserDeviceRequestBody(
    username: json['username'] as String,
    deviceId: json['deviceId'] as String?,
    deviceName: json['deviceName'] as String?,
    transactionPin: json['transactionPin'] as String?,
  );
}

Map<String, dynamic> _$UserDeviceRequestBodyToJson(
        UserDeviceRequestBody instance) =>
    <String, dynamic>{
      'username': instance.username,
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'transactionPin': instance.transactionPin,
    };
