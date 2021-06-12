import 'package:json_annotation/json_annotation.dart';

part 'ussd_configuration.g.dart';

@JsonSerializable()
class USSDConfiguration {

  @JsonKey(name:"id")
  int? id;

  @JsonKey(name:"baseCode")
  BaseCode? baseCode;

  @JsonKey(name:"body")
  String? body;

  @JsonKey(name:"name")
  String? name;

  @JsonKey(name:"description")
  String? description;

  @JsonKey(name:"preview")
  String? preview;

  USSDConfiguration();

  factory USSDConfiguration.fromJson(Object? data) => _$USSDConfigurationFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$USSDConfigurationToJson(this);

}

@JsonSerializable()
class BaseCode {
  @JsonKey(name:"id")
  int? id;
  @JsonKey(name:"baseCode")
  String? baseCode;

  BaseCode();

  factory BaseCode.fromJson(Object? data) => _$BaseCodeFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BaseCodeToJson(this);
}