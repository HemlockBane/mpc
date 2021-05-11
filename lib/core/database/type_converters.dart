import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';

class ListConverter extends TypeConverter<List<StateOfOrigin>?, String?>{
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