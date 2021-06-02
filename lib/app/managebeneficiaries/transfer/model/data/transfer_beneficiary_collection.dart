import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';


part 'transfer_beneficiary_collection.g.dart';

@JsonSerializable()
class TransferBeneficiaryCollection extends DataCollection<TransferBeneficiary>{
  TransferBeneficiaryCollection();
  factory TransferBeneficiaryCollection.fromJson(Object? data) => _$TransferBeneficiaryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$TransferBeneficiaryCollectionToJson(this);
}