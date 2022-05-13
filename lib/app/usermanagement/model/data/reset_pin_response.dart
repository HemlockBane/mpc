import 'package:json_annotation/json_annotation.dart';
part 'reset_pin_response.g.dart';

@JsonSerializable()
class ResetPINResponse {

  ResetPINResponse({this.message});

  @JsonKey(name: "message")
  final String? message;

  factory ResetPINResponse.fromJson(Object? data) =>
      _$ResetPINResponseFromJson(
          data as Map<String, dynamic>);

  Map<String, dynamic> toJson() =>
      _$ResetPINResponseToJson(this);

}