import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

import 'bill_beneficiary.dart';


part 'bill_beneficiary_collection.g.dart';

@JsonSerializable()
class BillBeneficiaryCollection extends DataCollection<BillBeneficiary>{
  BillBeneficiaryCollection();
  factory BillBeneficiaryCollection.fromJson(Object? data) => _$BillBeneficiaryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillBeneficiaryCollectionToJson(this);
}