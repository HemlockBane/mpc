import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

import 'country.dart';

part 'account_provider.g.dart';

@Entity(tableName: "account_providers", primaryKeys: ["bankCode"])
@JsonSerializable()
class AccountProvider {
  int? id;
  String? name;
  String? bankCode;
  String? bankShortName;
  String? centralBankCode;
  String? aptentRoutingKey;
  // Country? country;
  String? customerRMNodeType;
  String? customerAccountRMNodeType;

  @TypeConverters([ListStringConverter])
  List<String>? unsupportedFeatures = [];

  String? categoryId;

  @ignore
  bool? isSelected;

  AccountProvider({this.id,
    this.name,
    this.bankCode,
    this.bankShortName,
    this.centralBankCode,
    this.aptentRoutingKey,
    // this.country,
    this.customerRMNodeType,
    this.customerAccountRMNodeType,
    this.unsupportedFeatures,
    this.categoryId
  });


  factory AccountProvider.fromJson(Object? data) => _$AccountProviderFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AccountProviderToJson(this);


}