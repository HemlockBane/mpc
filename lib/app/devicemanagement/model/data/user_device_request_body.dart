import 'package:json_annotation/json_annotation.dart';

part 'user_device_request_body.g.dart';

@JsonSerializable()
class UserDeviceRequestBody {
  String username;
  String? deviceId;
  String? deviceName;
  String? transactionPin;

  UserDeviceRequestBody({
    required this.username,
    this.deviceId,
    this.deviceName,
    this.transactionPin
  });

  factory UserDeviceRequestBody.fromJson(Object? data) => _$UserDeviceRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$UserDeviceRequestBodyToJson(this);

}