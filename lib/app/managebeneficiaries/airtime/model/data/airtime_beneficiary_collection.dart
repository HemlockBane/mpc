import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';


part 'airtime_beneficiary_collection.g.dart';

@JsonSerializable()
class AirtimeBeneficiaryCollection extends DataCollection<AirtimeBeneficiary>{
  AirtimeBeneficiaryCollection();
  factory AirtimeBeneficiaryCollection.fromJson(Object? data) => _$AirtimeBeneficiaryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$AirtimeBeneficiaryCollectionToJson(this);
}