import 'package:json_annotation/json_annotation.dart';

part 'bvn_otp_validation_result.g.dart';

@JsonSerializable()
class BVNOTPValidationResult {

  @JsonKey(name:"onboarding_key")
  String? onBoardingKey;

  BVNOTPValidationResult();

  factory BVNOTPValidationResult.fromJson(Object? data) => _$BVNOTPValidationResultFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BVNOTPValidationResultToJson(this);

}