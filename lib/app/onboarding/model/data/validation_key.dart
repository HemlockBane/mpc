import 'package:json_annotation/json_annotation.dart';

part 'validation_key.g.dart';
@JsonSerializable()
class ValidationKey {

  @JsonKey(name:"onboardingKey")
  String? onboardingKey;

  @JsonKey(name:"bankRegistration")
  bool? bankRegistration;

  @JsonKey(name:"existing")
  bool? existing;

  ValidationKey();

  factory ValidationKey.fromJson(Object? data) => _$ValidationKeyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$ValidationKeyToJson(this);

}