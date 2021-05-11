import 'package:json_annotation/json_annotation.dart';

import 'country.dart';

part 'account_provider.g.dart';

@JsonSerializable()
class AccountProvider {
  int? id;
  String? name;
  String? centralBankCode;
  String? aptentRoutingKey;
  // Country? country;
  String? customerRMNodeType;
  String? customerAccountRMNodeType;
  List<String>? unsupportedFeatures = [];

  AccountProvider({this.id,
    this.name,
    this.centralBankCode,
    this.aptentRoutingKey,
    // this.country,
    this.customerRMNodeType,
    this.customerAccountRMNodeType,
    this.unsupportedFeatures});


  factory AccountProvider.fromJson(Object? data) => _$AccountProviderFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountProviderToJson(this);


}