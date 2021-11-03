import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'savings_product.g.dart';

@Entity(tableName: "savings_products")
@JsonSerializable()
class SavingsProduct {

  SavingsProduct({
    required this.id,
    this.createdOn,
    this.lastModifiedOn,
    this.name,
    this.shortDescription,
    this.longDescription,
    this.icon,
    this.headerImage,
    this.code,
    this.cbaSavingsAccountSchemeCode,
    this.interestRate,
    this.penalties,
  });

  @PrimaryKey()
  final int id;

  @JsonKey(name: "createdOn", fromJson: stringDateTime, toJson: millisToString)
  final int? createdOn;

  @JsonKey(name: "lastModifiedOn", fromJson: stringDateTime, toJson: millisToString)
  final int? lastModifiedOn;

  final String? name;
  final String? shortDescription;
  final String? longDescription;
  final String? icon;
  final String? headerImage;
  final String? code;
  final String? cbaSavingsAccountSchemeCode;
  final double? interestRate;
  final int? penalties;

  factory SavingsProduct.fromJson(Map<String, dynamic> json) => _$SavingsProductFromJson(json);

  Map<String, dynamic> toJson() => _$SavingsProductToJson(this);

}