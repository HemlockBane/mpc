import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

import 'package:json_annotation/json_annotation.dart';

part 'bill_beneficiary.g.dart';

@Entity(tableName: "bill_beneficiaries")
@JsonSerializable()
class BillBeneficiary implements Beneficiary {

  @JsonKey(name:"id")
  @PrimaryKey()
  final int id;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"billerCode")
  final String? billerCode;

  @JsonKey(name:"billerCategoryLogo")
  final String? billerCategoryLogo;

  @JsonKey(name:"biller")
  @TypeConverters([BillerConverter])
  final Biller? biller;

  @JsonKey(name:"billerProducts")
  @TypeConverters([ListBillerProductConverter])
  final List<BillerProduct>? billerProducts;

  @JsonKey(name:"billerName")
  final String? billerName;

  @JsonKey(name:"customerIdentity")
  final String? customerIdentity;

  // @JsonKey(name:"dateCreated")
  // @TypeConverters([DateListTypeConverter::class])
  // final List<int>? dateCreated;

  @JsonKey(name:"frequency")
  final int? frequency;

  @JsonKey(name:"lastUpdated")
  final int? lastUpdated;

  BillBeneficiary(
      {required this.id,
      this.name,
      this.billerCategoryLogo,
      this.billerCode,
      this.biller,
      this.billerProducts,
      this.billerName,
      this.customerIdentity,
      this.frequency,
      this.lastUpdated});


  factory BillBeneficiary.fromJson(Object? data) {
    final mapData = data as Map<String, dynamic>;
    mapData["billerCode"] = mapData["biller"]["code"];
    return _$BillBeneficiaryFromJson(mapData);
  }
  Map<String, dynamic> toJson() => _$BillBeneficiaryToJson(this);


  @override
  String getAccountName() => this.name ?? "";

  @override
  int? getBeneficiaryColor() => 0;

  @override
  String getBeneficiaryDigits() => this.customerIdentity ?? "";

  @override
  String? getBeneficiaryProviderCode() => "";

  @override
  String? getBeneficiaryProviderName() => this.biller?.identifierName ?? "";

  @override
  String getEntityId() => "";

  @override
  int getFrequency() => this.frequency ?? 0;

  @override
  int? getLastUpdated()  => this.lastUpdated ?? 0;

  @override
  bool isSelected() => false;

  @override
  void setSelected(bool selected) {
    // TODO: implement setSelected
  }

}