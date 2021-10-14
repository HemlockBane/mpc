import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/alternate_scheme_requirement.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_requirement.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_history_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_history_item.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_batch.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_history_item.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction_batch.dart';
import 'package:moniepoint_flutter/core/models/transaction_meta_data.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';

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

class AirtimeHistoryItemConverter extends TypeConverter<AirtimeHistoryItem?, String?>{
  @override
  AirtimeHistoryItem? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return AirtimeHistoryItem.fromJson(list);
  }

  @override
  String? encode(AirtimeHistoryItem? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class AirtimeServiceProviderConverter extends TypeConverter<AirtimeServiceProvider?, String?>{
  @override
  AirtimeServiceProvider? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return AirtimeServiceProvider.fromJson(list);
  }

  @override
  String? encode(AirtimeServiceProvider? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class BillHistoryItemConverter extends TypeConverter<BillHistoryItem?, String?>{
  @override
  BillHistoryItem? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return BillHistoryItem.fromJson(list);
  }

  @override
  String? encode(BillHistoryItem? value) {
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

class AdditionalFieldsConverter extends TypeConverter<Map<String, InputField>?, String?>{
  @override
  Map<String, InputField>? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final Map<dynamic, dynamic> data = jsonDecode(databaseValue);
    return data.map((key, value) => MapEntry(key, InputField.fromJson(value)));
  }

  @override
  String? encode(Map<String, InputField>? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}



class BillerConverter extends TypeConverter<Biller?, String?>{
  @override
  Biller? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return Biller.fromJson(list);
  }

  @override
  String? encode(Biller? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class ListBillerProductConverter extends TypeConverter<List<BillerProduct>?, String?>{
  @override
  List<BillerProduct>? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final List<dynamic> list = jsonDecode(databaseValue);
    return list.map((e) => BillerProduct.fromJson(e)).toList();
  }

  @override
  String? encode(List<BillerProduct>? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}


class TransactionTypeConverter extends TypeConverter<TransactionType?, String?>{
  @override
  TransactionType? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final TransactionType type = enumFromString<TransactionType>(TransactionType.values, databaseValue);
    return type;
  }

  @override
  String? encode(TransactionType? value) {
    return (value != null)  ? describeEnum(value) : null;
  }
}

class TransactionCategoryConverter extends TypeConverter<TransactionCategory?, String?>{
  @override
  TransactionCategory? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final TransactionCategory type = enumFromString<TransactionCategory>(TransactionCategory.values, databaseValue);
    return type;
  }

  @override
  String? encode(TransactionCategory? value) {
    return (value != null)  ? describeEnum(value) : null;
  }
}

class TransactionChannelConverter extends TypeConverter<TransactionChannel?, String?>{
  @override
  TransactionChannel? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final TransactionChannel type = enumFromString<TransactionChannel>(TransactionChannel.values, databaseValue);
    return type;
  }

  @override
  String? encode(TransactionChannel? value) {
    return (value != null) ? describeEnum(value) : null;
  }
}

class TransactionMetaDataConverter extends TypeConverter<TransactionMetaData?, String?>{
  @override
  TransactionMetaData? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic type = jsonDecode(databaseValue);
    return TransactionMetaData.fromJson(type);
  }

  @override
  String? encode(TransactionMetaData? value) {
    return (value != null) ? jsonEncode(value) : null;
  }
}


class SchemeRequirementConverter extends TypeConverter<SchemeRequirement?, String?>{
  @override
  SchemeRequirement? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return SchemeRequirement.fromJson(list);
  }

  @override
  String? encode(SchemeRequirement? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class AlternateSchemeRequirementConverter extends TypeConverter<AlternateSchemeRequirement?, String?>{
  @override
  AlternateSchemeRequirement? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic list = jsonDecode(databaseValue);
    return AlternateSchemeRequirement.fromJson(list);
  }

  @override
  String? encode(AlternateSchemeRequirement? value) {
    return (value != null)  ? jsonEncode(value) : null;
  }
}

class DateStringToLongConverter extends TypeConverter<String?, int?>{
  @override
  String? decode(int? databaseValue) {
    if(databaseValue == null) return null;
    final DateTime list = DateTime.fromMillisecondsSinceEpoch(databaseValue);
    return DateFormat().format(list);
  }

  @override
  int? encode(String? value) {
    return (value != null)  ? DateTime.parse(value).millisecondsSinceEpoch : null;
  }
}


class LocationConverter extends TypeConverter<Location?, String?>{
  @override
  Location? decode(String? databaseValue) {
    if(databaseValue == null) return null;
    final dynamic type = jsonDecode(databaseValue);
    return Location.fromJson(type);
  }

  @override
  String? encode(Location? value) {
    return (value != null) ? jsonEncode(value) : null;
  }
}



int stringDateTime(String a) {
  final parsedDate = DateTime.parse(a);
  if(parsedDate.isUtc && ServiceConfig.ENV == "dev") {
    return parsedDate.subtract(Duration(hours: 1)).millisecondsSinceEpoch;
  }
  return parsedDate.millisecondsSinceEpoch;
}
// class DateListTypeConverter extends TypeConverter<List<int>?, int?>{
//   @override
//   List<int>? decode(int? databaseValue) {
//     if(databaseValue == null) return null;
//     final List<dynamic> list = jsonDecode(databaseValue);
//     return list.map((e) => BoundedCharges.fromJson(e)).toList();
//   }
//
//   @override
//   int? encode(List<int>? value) {
//     return (value != null)  ? jsonEncode(value) : null;
//   }
// }