import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';

import 'package:json_annotation/json_annotation.dart';

part 'card_activation_response.g.dart';

@JsonSerializable()
class CardActivationResponse extends LivelinessValidationResponse {
  //
  // @JsonKey(name: "status")
  // bool? status;

  @JsonKey(name: "message")
  String? message;

  CardActivationResponse();

  factory CardActivationResponse.fromJson(Object? data) => _$CardActivationResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CardActivationResponseToJson(this);

}