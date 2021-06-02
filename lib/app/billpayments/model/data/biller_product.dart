
import 'package:json_annotation/json_annotation.dart';
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'biller_product.g.dart';

@Entity(tableName: 'biller_products')
@JsonSerializable()
class BillerProduct  {

  String? billerCode;

  @JsonKey(name:"id")
  @PrimaryKey()
  final int id;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"code")
  final String? code;

  @JsonKey(name:"amount")
  final double? amount;

  @JsonKey(name:"fee")
  final double? fee;

  @JsonKey(name:"paymentCode")
  final String? paymentCode;

  @JsonKey(name:"currencySymbol")
  final String? currencySymbol;

  @JsonKey(name:"active")
  final bool? active;

  @JsonKey(name:"priceFixed")
  final bool? priceFixed;

  @JsonKey(name:"minimumAmount")
  final double? minimumAmount;

  @JsonKey(name:"maximumAmount")
  final double? maximumAmount;

  @JsonKey(name:"identifierName")
  final String? identifierName;

  @JsonKey(name:"additionalFieldsMap")
  @TypeConverters([AdditionalFieldsConverter])
  final Map<String, InputField>? additionalFieldsMap;

  BillerProduct(
      {this.billerCode,
      required this.id,
      this.name,
      this.code,
      this.amount,
      this.fee,
      this.paymentCode,
      this.currencySymbol,
      this.active,
      this.priceFixed,
      this.minimumAmount,
      this.maximumAmount,
      this.identifierName,
      this.additionalFieldsMap});


  factory BillerProduct.fromJson(Object? data) => _$BillerProductFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillerProductToJson(this);

}

@JsonSerializable()
class InputField  {
  @ignore
  String? key;

  @ignore
  String? fieldLabel = "";

  @ignore
  String? fieldError = "";

  @ignore
  String? fieldValue;

  @JsonKey(name:"dataType")
  final String dataType;

  @JsonKey(name:"required")
  final bool required;

  @JsonKey(name:"minimumLength")
  final double? minimumLength;

  @JsonKey(name:"maximumLength")
  final double? maximumLength;

  InputField(
      this.dataType, this.required, this.minimumLength, this.maximumLength,
      {this.key, this.fieldLabel, this.fieldError, this.fieldValue});

  factory InputField.fromJson(Object? data) => _$InputFieldFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$InputFieldToJson(this);

}