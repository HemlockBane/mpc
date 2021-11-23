import 'package:floor/floor.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_dao.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item_dao.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_dao.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_savings_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_dao.dart';
import 'package:moniepoint_flutter/core/database/migrations/app_migrations.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_database.dart';

class DatabaseModule {

  static Future<void> inject() async {

    GetIt.I.registerSingletonAsync<AppDatabase>(() async =>
    await $FloorAppDatabase
        .databaseBuilder('moniepoint_db.db')
        .addMigrations(AppMigration().getMigrations())
        .build()
    );

    final db = await GetIt.I.getAsync<AppDatabase>();

    GetIt.I.registerLazySingleton<NationalityDao>(() {
      return db.nationalityDao;
    });
    // GetIt.I.re<NationalityDao>(() async {
    //   final db = await GetIt.I.getAsync<AppDatabase>();
    //   return db.nationalityDao;
    // });

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

    GetIt.I.registerSingletonAsync<AirtimeDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.airtimeDao;
    });

    GetIt.I.registerSingletonAsync<AirtimeBeneficiaryDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.airtimeBeneficiaryDao;
    });

    GetIt.I.registerSingletonAsync<AirtimeServiceProviderDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.serviceProviderDao;
    });

    GetIt.I.registerSingletonAsync<AirtimeServiceProviderItemDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.serviceProviderItemDao;
    });


    //Bills
    GetIt.I.registerSingletonAsync<BillsDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.billsDao;
    });

    GetIt.I.registerSingletonAsync<BillBeneficiaryDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.billBeneficiaryDao;
    });

    GetIt.I.registerSingletonAsync<BillerDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.billerDao;
    });

    GetIt.I.registerSingletonAsync<BillerCategoryDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.billerCategoryDao;
    });

    GetIt.I.registerSingletonAsync<BillerProductDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.billerProductDao;
    });

    GetIt.I.registerLazySingleton<TransactionDao>(() {
      return db.transactionDao;
    });

    GetIt.I.registerSingletonAsync<SchemeDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.schemeDao;
    });

    GetIt.I.registerSingletonAsync<FlexSavingsDao>(() async {
      final db = await GetIt.I.getAsync<AppDatabase>();
      return db.flexSavingsDao;
    });
  }
}