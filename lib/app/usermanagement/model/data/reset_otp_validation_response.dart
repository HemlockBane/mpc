import 'package:json_annotation/json_annotation.dart';part 'reset_otp_validation_response.g.dart';

@JsonSerializable()
class ResetOtpValidationResponse {

  ResetOtpValidationResponse({this.otpValidationKey});

  @JsonKey(name: "validationKey")
  final String? otpValidationKey;

  factory ResetOtpValidationResponse.fromJson(Object? data) =>
      _$ResetOtpValidationResponseFromJson(
          data as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      _$ResetOtpValidationResponseToJson(this);

}