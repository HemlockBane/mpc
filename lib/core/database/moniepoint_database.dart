import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/scheme_dao.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_dao.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/bills/model/data/bill_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_dao.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'moniepoint_database.g.dart';

@TypeConverters([ListStateConverter])
@Database(version: 1, entities: [
  Nationality,
  TransferBeneficiary,
  AccountProvider,
  FeeVatConfig,
  SingleTransferTransaction,
  AirtimeTransaction,
  AirtimeBeneficiary,
  AirtimeServiceProvider,
  AirtimeServiceProviderItem,
  BillTransaction,
  BillBeneficiary,
  Biller,
  BillerCategory,
  BillerProduct,
  AccountTransaction,
  Tier
])
abstract class AppDatabase extends FloorDatabase {
  NationalityDao get nationalityDao;

  TransferBeneficiaryDao get transferBeneficiaryDao;

  InstitutionDao get institutionDao;

  FeeVatConfigDao get feeVatConfigDao;

  TransferDao get transferDao;

  AirtimeDao get airtimeDao;

  AirtimeBeneficiaryDao get airtimeBeneficiaryDao;

  AirtimeServiceProviderDao get serviceProviderDao;

  AirtimeServiceProviderItemDao get serviceProviderItemDao;

  BillsDao get billsDao;

  BillBeneficiaryDao get billBeneficiaryDao;

  BillerDao get billerDao;

  BillerCategoryDao get billerCategoryDao;

  BillerProductDao get billerProductDao;

  TransactionDao get transactionDao;

  SchemeDao get schemeDao;
}