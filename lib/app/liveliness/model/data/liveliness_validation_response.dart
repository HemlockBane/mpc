import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

part 'liveliness_validation_response.g.dart';

@JsonSerializable()
class LivelinessValidationResponse {
  LivelinessError? livelinessError;
  ClientError? faceMatchError;

  LivelinessValidationResponse();

  factory LivelinessValidationResponse.fromJson(Map<String, dynamic> data) => _$LivelinessValidationResponseFromJson(data);
  Map<String, dynamic> toJson() => _$LivelinessValidationResponseToJson(this);

}