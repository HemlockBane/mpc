import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

import '../../../beneficiary.dart';
import 'package:json_annotation/json_annotation.dart';

part 'airtime_beneficiary.g.dart';


@Entity(tableName: "airtime_beneficiaries")
@JsonSerializable()
class AirtimeBeneficiary extends Beneficiary {

  @JsonKey(name:"id")
  @PrimaryKey()
  final int id;

  @JsonKey(name:"name")
  final String? name;

  @JsonKey(name:"phoneNumber")
  final String? phoneNumber;

  @JsonKey(name:"serviceProvider")
  @TypeConverters([AirtimeServiceProviderConverter])
  final AirtimeServiceProvider? serviceProvider;

  @JsonKey(name:"frequency")
  int? frequency;

  @JsonKey(name:"lastUpdated")
  int? lastUpdated;

  AirtimeBeneficiary({
    required this.id,
    this.name,
    this.phoneNumber,
    this.serviceProvider,
    this.frequency,
    this.lastUpdated
  });

  factory AirtimeBeneficiary.fromJson(Object? data) => _$AirtimeBeneficiaryFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeBeneficiaryToJson(this);


  @override
  int getRecordId() {
    return this.id;
  }

  @override
  String getEntityId() {
    return serviceProvider?.billerId ?? "";
  }

  @override
  String getAccountName() {
    return name ?? "";
  }

  @override
  String getBeneficiaryDigits() {
    return phoneNumber ?? "";
  }

  @override
  String getBeneficiaryProviderName() {
    return serviceProvider?.name ?? "";
  }

  @override
  String getBeneficiaryProviderCode() {
    return serviceProvider?.code ?? "";
  }

  @override
  int getBeneficiaryColor() {
    return 0;
  }

  @override
  bool isSelected() {
    return false;
  }

  @override
  void setSelected(bool selected) {

  }

  @override
  int? getLastUpdated() {
    return lastUpdated;
  }
}
