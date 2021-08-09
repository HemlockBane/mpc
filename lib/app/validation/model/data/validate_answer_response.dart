import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';

import 'switch_validation_key.dart';

part 'validate_answer_response.g.dart';

@JsonSerializable()
class ValidateAnswerResponse extends LivelinessValidationResponse{
  @JsonKey(name:"userCustomerTypes")
  final List<String>? userCustomerTypes;
  @JsonKey(name:"validationKey")
  final String? validationKey;
  @JsonKey(name:"accessToken")
  final String? accessToken;
  @JsonKey(name:"livelinessValidationKey")
  final String? livelinessValidationKey;

  ValidateAnswerResponse(
      {this.userCustomerTypes,
      this.validationKey,
      this.accessToken,
      this.livelinessValidationKey}):super();

  factory ValidateAnswerResponse.fromJson(Object? data) => _$ValidateAnswerResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidateAnswerResponseToJson(this);

}