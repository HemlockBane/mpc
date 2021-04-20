// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bvn_otp_validation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BVNOTPValidationRequest _$BVNOTPValidationRequestFromJson(
    Map<String, dynamic> json) {
  return BVNOTPValidationRequest()
    ..bvn = json['bvn'] as String?
    ..phoneNumber = json['phone'] as String?
    ..otp = json['otp'] as String?
    ..dob = json['dob'] as String?;
}

Map<String, dynamic> _$BVNOTPValidationRequestToJson(
        BVNOTPValidationRequest instance) =>
    <String, dynamic>{
      'bvn': instance.bvn,
      'phone': instance.phoneNumber,
      'otp': instance.otp,
      'dob': instance.dob,
    };
