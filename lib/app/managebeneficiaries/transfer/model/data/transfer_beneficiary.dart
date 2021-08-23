import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';

part 'transfer_beneficiary.g.dart';

@Entity(tableName:"transfer_beneficiaries", primaryKeys : ["accountName", "accountNumber", "accountProviderCode"])
@JsonSerializable()
class TransferBeneficiary extends Beneficiary {

  TransferBeneficiary({
    this.id,
    required this.accountName,
    required this.accountNumber,
    this.bvn,
    this.nameEnquiryReference,
    this.accountProviderName,
    this.accountProviderCode,
    this.frequency,
    this.lastUpdated
  });

  final int? id;

  final String accountName;

  final String accountNumber;

  final String? bvn;

  final String? nameEnquiryReference;

  final String? accountProviderName;

  final String? accountProviderCode;

  final int? frequency;

  final int? lastUpdated;

  factory TransferBeneficiary.fromJson(Object? data) => _$TransferBeneficiaryFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferBeneficiaryToJson(this);

  @override
  int getRecordId() {
    return this.id ?? 0;
  }
  @override
  String getAccountName() {
    return this.accountName;
  }

  @override
  int getBeneficiaryColor() {
    // TODO: implement getBeneficiaryColor
    throw UnimplementedError();
  }

  @override
  String getBeneficiaryDigits() {
    return this.accountNumber;
  }

  @override
  String? getBeneficiaryProviderCode() {
    return this.accountProviderCode;
  }

  @override
  String? getBeneficiaryProviderName() {
    return this.accountProviderName;
  }

  @override
  String getEntityId() {
    return "${this.accountNumber}";
  }

  @override
  int getFrequency() {
    return this.frequency ?? 0;
  }

  @override
  int? getLastUpdated() {
    return this.lastUpdated;
  }

  @override
  bool isSelected() {
    // TODO: implement isSelected
    throw UnimplementedError();
  }

  @override
  void setSelected(bool selected) {
    // TODO: implement setSelected
  }
}
