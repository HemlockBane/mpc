import 'package:json_annotation/json_annotation.dart';

import 'switch_validation_key.dart';

part 'validate_phone_otp_response.g.dart';

@JsonSerializable()
class ValidatePhoneOtpResponse {
  @JsonKey(name:"phone_number_validation_key")
  final String? phoneNumberValidationKey;

  ValidatePhoneOtpResponse(this.phoneNumberValidationKey);

  factory ValidatePhoneOtpResponse.fromJson(Object? data) => _$ValidatePhoneOtpResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidatePhoneOtpResponseToJson(this);

}