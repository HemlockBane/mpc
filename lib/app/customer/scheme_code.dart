import 'package:json_annotation/json_annotation.dart';

import 'account_provider.dart';

part 'scheme_code.g.dart';

@JsonSerializable()
class SchemeCode {
  int id;
  String name;
  String? description;
  String? code;
  AccountProvider? accountProvider;
  List<String>? unsupportedFeatures;
  String? customerType;
  List<int>? timeAdded;
  String? defaultAccountRole;

  SchemeCode({required this.id,
    required this.name,
    this.description,
    this.code,
    this.accountProvider,
    this.unsupportedFeatures,
    this.customerType,
    this.timeAdded,
    this.defaultAccountRole});


  factory SchemeCode.fromJson(Object? data) => _$SchemeCodeFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$SchemeCodeToJson(this);


}
