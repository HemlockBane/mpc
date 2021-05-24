import 'package:floor/floor.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_dao.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_database.dart';

class DatabaseModule {

  static void inject() async {
    final migration = Migration(3, 4, (migrate) async {

    });
    // final migration2 = Migration(2, 3, (migrate) async {
    //   migrate.execute("DROP DATABASE moniepoint_db");
    // });

    GetIt.I.registerSingletonAsync<AppDatabase>(() async =>
    await $FloorAppDatabase
        .databaseBuilder('moniepoint_db.db')
        .addMigrations([migration])
        .build()
    );

    GetIt.I.registerSingletonAsync<NationalityDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.nationalityDao;
    });

    GetIt.I.registerSingletonAsync<TransferBeneficiaryDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.transferBeneficiaryDao;
    });

    GetIt.I.registerSingletonAsync<InstitutionDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.institutionDao;
    });

    GetIt.I.registerSingletonAsync<FeeVatConfigDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.feeVatConfigDao;
    });

    GetIt.I.registerSingletonAsync<TransferDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.transferDao;
    });
  }
}