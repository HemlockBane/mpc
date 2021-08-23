import 'package:json_annotation/json_annotation.dart';

part 'trigger_otp_request.g.dart';

@JsonSerializable(includeIfNull: false)
class TriggerOtpRequestBody {

  @JsonKey(name:"username")
  String? username;
  @JsonKey(name:"customerType")
  String? customerType;
  @JsonKey(name:"validationKey")
  String? validationKey;

  TriggerOtpRequestBody();

  factory TriggerOtpRequestBody.fromJson(Object? data) => _$TriggerOtpRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TriggerOtpRequestBodyToJson(this);

  TriggerOtpRequestBody withUsername(String username) {
    this.username = username;
    return this;
  }

  TriggerOtpRequestBody withValidationKey(String validationKey) {
    this.validationKey = validationKey;
    return this;
  }

}