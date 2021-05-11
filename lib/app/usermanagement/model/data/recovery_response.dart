import 'package:json_annotation/json_annotation.dart';

import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';

part 'recovery_response.g.dart';

@JsonSerializable()
class RecoveryResponse {
  OTP? activation;
  SecurityQuestion? securityQuestion;
  OTP? otp;
  String? key;
  bool? success;

  RecoveryResponse();

  factory RecoveryResponse.fromJson(Object? data) => _$RecoveryResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RecoveryResponseToJson(this);

}