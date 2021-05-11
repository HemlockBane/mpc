// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'validate_device_switch_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValidateDeviceSwitchRequestBody _$ValidateDeviceSwitchRequestBodyFromJson(
    Map<String, dynamic> json) {
  return ValidateDeviceSwitchRequestBody()
    ..username = json['username'] as String?
    ..customerType = json['customerType'] as String?
    ..validationKey = json['validationKey'] as String?
    ..authenticationRequest = json['authenticationRequest'] == null
        ? null
        : AuthenticationRequest.fromJson(
            json['authenticationRequest'] as Object);
}

Map<String, dynamic> _$ValidateDeviceSwitchRequestBodyToJson(
        ValidateDeviceSwitchRequestBody instance) =>
    <String, dynamic>{
      'username': instance.username,
      'customerType': instance.customerType,
      'validationKey': instance.validationKey,
      'authenticationRequest': instance.authenticationRequest,
    };
