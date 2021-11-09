import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/flex_saving.dart';
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
    this.flexSavings = const []
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
  final List<FlexSaving>? flexSavings;

  factory SavingsProduct.fromJson(Map<String, dynamic> json) => _$SavingsProductFromJson(json);

  SavingsProduct withFlexSavings(List<FlexSaving>? flexSavings) {
    if(flexSavings == null) return this;
    return SavingsProduct(
      id: this.id,
      createdOn:  this.createdOn,
      name: this.name,
      shortDescription: this.shortDescription,
      longDescription: this.longDescription,
      icon: this.icon,
      headerImage: this.headerImage,
      code: this.code,
      cbaSavingsAccountSchemeCode: this.cbaSavingsAccountSchemeCode,
      interestRate: this.interestRate,
      penalties: this.penalties,
      flexSavings: flexSavings
    );
  }

  Map<String, dynamic> toJson() => _$SavingsProductToJson(this);

}