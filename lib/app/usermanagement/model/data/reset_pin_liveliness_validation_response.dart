import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

part 'reset_pin_liveliness_validation_response.g.dart';

@JsonSerializable()
class ResetPinLivelinessValidationResponse
    extends LivelinessValidationResponse {

  ResetPinLivelinessValidationResponse({this.livelinessValidationKey});

  final String? livelinessValidationKey;

  factory ResetPinLivelinessValidationResponse.fromJson(Object? data) =>
      _$ResetPinLivelinessValidationResponseFromJson(
          data as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      _$ResetPinLivelinessValidationResponseToJson(this);
}