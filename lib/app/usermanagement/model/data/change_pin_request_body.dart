import 'package:json_annotation/json_annotation.dart';

part 'change_pin_request_body.g.dart';

@JsonSerializable()
class ChangePinRequestBody  {
  @JsonKey(name:"oldPin")
  String? oldPin;

  @JsonKey(name:"newPin")
  String? newPin;

  ChangePinRequestBody();

  factory ChangePinRequestBody.fromJson(Object? data) => _$ChangePinRequestBodyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ChangePinRequestBodyToJson(this);

  ChangePinRequestBody withOldPin(String oldPin) {
    this.oldPin = oldPin;
    return this;
  }

  ChangePinRequestBody withNewPin(String newPin) {
    this.newPin = newPin;
    return this;
  }

}