import 'package:moniepoint_flutter/app/branches/model/data/branch_info.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch_info_collection.g.dart';

@JsonSerializable()
class BranchInfoCollection extends DataCollection<BranchInfo> {
  BranchInfoCollection();
  factory BranchInfoCollection.fromJson(Object? data) => _$BranchInfoCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BranchInfoCollectionToJson(this);
}