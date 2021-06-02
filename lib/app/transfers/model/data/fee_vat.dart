import 'package:json_annotation/json_annotation.dart';

part 'fee_vat.g.dart';

@JsonSerializable()
class FeeVat {
  final int? minorAmount;
  final int? minorFee;
  final int? minorVat;
  final String? sourceBankCode;
  final String? sinkBankCode;

  FeeVat({this.minorAmount,
        this.minorFee,
        this.minorVat,
        this.sourceBankCode,
        this.sinkBankCode
  });

  factory FeeVat.fromJson(Object? data) => _$FeeVatFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$FeeVatToJson(this);

}