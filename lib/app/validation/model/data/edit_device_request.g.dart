// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditDeviceRequestBody _$EditDeviceRequestBodyFromJson(
    Map<String, dynamic> json) {
  return EditDeviceRequestBody()
    ..deviceId = json['deviceId'] as String?
    ..fingerPrintKey = json['fingerPrintKey'] as String?
    ..name = json['name'] as String?
    ..type = json['type'] as String?
    ..imei = json['imei'] as String?
    ..key = json['livelinessValidationKey'] as String?
    ..username = json['username'] as String?;
}

Map<String, dynamic> _$EditDeviceRequestBodyToJson(
        EditDeviceRequestBody instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'fingerPrintKey': instance.fingerPrintKey,
      'name': instance.name,
      'type': instance.type,
      'imei': instance.imei,
      'livelinessValidationKey': instance.key,
      'username': instance.username,
    };
