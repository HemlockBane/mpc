import 'package:json_annotation/json_annotation.dart';


part 'switch_validation_key.g.dart';

@JsonSerializable()
class SwitchValidationKey {

  @JsonKey(name:"key")
  final String key;

  SwitchValidationKey(this.key);

  factory SwitchValidationKey.fromJson(Object? data) => _$SwitchValidationKeyFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SwitchValidationKeyToJson(this);


}