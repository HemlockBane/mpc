import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_batch.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_history_item.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';

class ListStringConverter extends TypeConverter<List<String>?, String?>{
  @override
  List<String>? decode(String? databaseValue) {
    if(databaseValue == null || databaseValue.isEmpty) return null;
    final List<dynamic> list = jsonDecode(databaseValue);
    return list.map((e) => e.toString()).toList();
  }

  @override
  String? encode(List<String>? value) {
    if(value == null) return null;
    return jsonEncode(value);
  }

}

class ListIntConverter extends TypeConverter<List<int>?, String?>{
  @override
  List<int>? decode(String? databaseValue) {
    if(databaseValue == null || databaseValue.isEmpty) return null;
    final List<dynamic> list = jsonDecode(databaseValue);
    return list.map((e) => e as int).toList();
  }

  @override
  String? encode(List<int>? value) {
    if(value == null) return null;
    return jsonEncode(value);
  }

}

class ListStateConverter extends TypeConverter<List<StateOfOrigin>?, String?>{
  @override
  List<StateOfOrigin>? decode(String? databaseValue) {
    final List<dynamic> list = jsonDecode(databaseValue!);
    return list.map((e) => StateOfOrigin.fromJson(e)).toList();
  }

  @override
  String? encode(List<StateOfOrigin>? value) {
    return jsonEncode(value);
  }

}

class TransactionBatchConverter extends TypeConverter<TransactionBatch?, String?>{
  @override
  TransactionBatch? decode(String? databaseValue) {
    final dynamic list = jsonDecode(databaseValue!);
    return TransactionBatch.fromJson(list);
  }

  @override
  String? encode(TransactionBatch? value) {
    return jsonEncode(value);
  }
}

class TransferBatchConverter extends TypeConverter<TransferBatch?, String?>{
  @override
  TransferBatch? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return TransferBatch.fromJson(list);
  }

  @override
  String? encode(TransferBatch? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class TransferHistoryItemConverter extends TypeConverter<TransferHistoryItem?, String?>{
  @override
  TransferHistoryItem? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return TransferHistoryItem.fromJson(list);
  }

  @override
  String? encode(TransferHistoryItem? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}


class ListBoundedChargesConverter extends TypeConverter<List<BoundedCharges>?, String?>{
  @override
  List<BoundedCharges>? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final List<dynamic> list = jsonDecode(databaseValue);
    return list.map((e) => BoundedCharges.fromJson(e)).toList();
  }

  @override
  String? encode(List<BoundedCharges>? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}
