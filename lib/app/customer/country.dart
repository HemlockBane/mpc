import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable()
class Country {
  int? id;
  String? code;
  String? name;
  String? postCode;
  String? isoCode;
  String? base64Icon;
  bool? active;
  List<dynamic>? states;

  Country({this.id,
    this.code,
    this.name,
    this.postCode,
    this.isoCode,
    this.base64Icon,
    this.active,
    this.states
  });

  factory Country.fromJson(Object? data) => _$CountryFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$CountryToJson(this);

}