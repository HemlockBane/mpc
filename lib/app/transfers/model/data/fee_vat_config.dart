import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'fee_vat_config.g.dart';

@Entity(tableName: "fee_vat_configs", primaryKeys : ["id", "chargeType"])
@JsonSerializable()
class FeeVatConfig {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String chargeType;
  final double? minorFee;
  final double? minorVat;
  @TypeConverters([ListBoundedChargesConverter])
  final List<BoundedCharges>? boundedCharges;

  FeeVatConfig(
      {this.id,
      required this.chargeType,
      this.minorFee,
      this.minorVat,
      this.boundedCharges});

  factory FeeVatConfig.fromJson(Object? data) => _$FeeVatConfigFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FeeVatConfigToJson(this);
}

@JsonSerializable()
class BoundedCharges {
  final int? id;
  final String? transactionType;
  final int? feeMinor;
  final int? vatMinor;
  final int? lowerLimitMinor;

  BoundedCharges({this.id,
        this.transactionType,
        this.feeMinor,
        this.vatMinor,
        this.lowerLimitMinor});

  factory BoundedCharges.fromJson(Object? data) => _$BoundedChargesFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BoundedChargesToJson(this);

}