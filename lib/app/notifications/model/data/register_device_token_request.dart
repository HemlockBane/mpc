import 'package:json_annotation/json_annotation.dart';

part 'register_device_token_request.g.dart';

@JsonSerializable()
class RegisterDeviceTokenRequest {
  String deviceToken;

  RegisterDeviceTokenRequest({
    required this.deviceToken
  });

  factory RegisterDeviceTokenRequest.fromJson(Object? data) =>
      _$RegisterDeviceTokenRequestFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RegisterDeviceTokenRequestToJson(this);

}