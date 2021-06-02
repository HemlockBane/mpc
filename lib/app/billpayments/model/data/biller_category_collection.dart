import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
part 'biller_category_collection.g.dart';

@JsonSerializable()
class BillerCategoryCollection extends DataCollection<BillerCategory> {
  BillerCategoryCollection();
  factory BillerCategoryCollection.fromJson(Object? data) => _$BillerCategoryCollectionFromJson(data as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$BillerCategoryCollectionToJson(this);
}