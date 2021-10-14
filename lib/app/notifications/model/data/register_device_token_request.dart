import 'package:json_annotation/json_annotation.dart';

part 'register_device_token_request.g.dart';

@JsonSerializable()
class RegisterDeviceTokenRequest {
  String deviceToken;

  RegisterDeviceTokenRequest({
    required this.deviceToken
  });

  factory RegisterDeviceTokenRequest.fromJson(Object? data) {
    final jsonMap = data as Map<String, dynamic>;
    final a = _$RegisterDeviceTokenRequestFromJson(jsonMap);
    return a;
  }
  Map<String, dynamic> toJson() => _$RegisterDeviceTokenRequestToJson(this);

}