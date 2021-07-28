import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

part 'recovery_response.g.dart';

@JsonSerializable()
class RecoveryResponse extends LivelinessValidationResponse{
  String? notificationServiceResponseCode;
  String? otpValidationKey;
  String? userCode;
  String? username;
  String? livelinessCheckRef;

  RecoveryResponse() : super();

  factory RecoveryResponse.fromJson(Object? data) => _$RecoveryResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RecoveryResponseToJson(this);

}