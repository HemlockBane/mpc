
import 'package:json_annotation/json_annotation.dart';

part 'card_otp_validation_response.g.dart';


@JsonSerializable()
class CardOtpValidationResponse {

  String? otpValidationKey;

  CardOtpValidationResponse();

  factory CardOtpValidationResponse.fromJson(Object? data) => _$CardOtpValidationResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardOtpValidationResponseToJson(this);

}