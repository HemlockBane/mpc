import 'package:json_annotation/json_annotation.dart';

part 'finger_print_auth_request_body.g.dart';

@JsonSerializable()
class FingerPrintAuthRequestBody {
  @JsonKey(name:"deviceId")
  String? deviceId;

  @JsonKey(name:"fingerprintKey")
  String? fingerprintKey;

  FingerPrintAuthRequestBody withDeviceId(String deviceId) {
    this.deviceId = deviceId;
    return this;
  }

  FingerPrintAuthRequestBody withFingerprintKey(String fingerprintKey) {
    this.fingerprintKey = fingerprintKey;
    return this;
  }

  FingerPrintAuthRequestBody();

  factory FingerPrintAuthRequestBody.fromJson(Object? data) => _$FingerPrintAuthRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FingerPrintAuthRequestBodyToJson(this);

}