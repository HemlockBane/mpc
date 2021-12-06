import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flex_saving_scheme.g.dart';


@JsonSerializable()
class FlexSavingScheme {

  FlexSavingScheme({
    required this.id,
    this.name,
    this.accountSchemeCode,
    this.isDefault,
  });

  final int? id;
  final String? name;
  final String? accountSchemeCode;
  @JsonKey(name: "default")
  final bool? isDefault;

  factory FlexSavingScheme.fromJson(Map<String, dynamic> json) => _$FlexSavingSchemeFromJson(json);
  Map<String, dynamic> toJson() => _$FlexSavingSchemeToJson(this);

}
