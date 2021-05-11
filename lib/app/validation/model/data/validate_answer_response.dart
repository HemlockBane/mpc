import 'package:json_annotation/json_annotation.dart';

import 'switch_validation_key.dart';

part 'validate_answer_response.g.dart';

@JsonSerializable()
class ValidateAnswerResponse {
  @JsonKey(name:"userCustomerTypes")
  final List<String>? userCustomerTypes;
  @JsonKey(name:"validationKey")
  final SwitchValidationKey validationKey;
  @JsonKey(name:"accessToken")
  final String? accessToken;

  ValidateAnswerResponse(this.userCustomerTypes, this.validationKey, this.accessToken);

  factory ValidateAnswerResponse.fromJson(Object? data) => _$ValidateAnswerResponseFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidateAnswerResponseToJson(this);

}