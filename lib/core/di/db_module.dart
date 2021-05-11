import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_database.dart';

class DatabaseModule {

  static void inject() async {
    GetIt.I.registerSingletonAsync<AppDatabase>(() async =>
    await $FloorAppDatabase.databaseBuilder('moniepoint_db.db').build());

    GetIt.I.registerSingletonAsync<NationalityDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.nationalityDao;
    });
  }
}