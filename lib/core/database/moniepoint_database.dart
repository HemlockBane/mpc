import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';


part 'moniepoint_database.g.dart';

@TypeConverters([ListConverter])
@Database(version: 1, entities: [Nationality])
abstract class AppDatabase extends FloorDatabase {
  NationalityDao get nationalityDao;
}