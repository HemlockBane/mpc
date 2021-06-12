import 'package:json_annotation/json_annotation.dart';

part 'system_configuration.g.dart';

@JsonSerializable()
class SystemConfiguration {

  SystemConfiguration({
    this.id,
    this.name,
    this.key,
    this.value,
    this.type,
    this.description,
    this.createdAt,
    this.lastModifiedAt,
  });

  int? id;
  String? name;
  String? key;
  String? value;
  String? type;
  String? description;
  String? createdAt;
  String? lastModifiedAt;

  factory SystemConfiguration.fromJson(Map<String, dynamic> json) => _$SystemConfigurationFromJson(json);
  Map<String, dynamic> toJson() => _$SystemConfigurationToJson(this);

}
