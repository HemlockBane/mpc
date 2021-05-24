import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/nationality_dao.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/app/institutions/institution_dao.dart';
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
@Database(version: 1, entities: [Nationality, TransferBeneficiary, AccountProvider, FeeVatConfig, SingleTransferTransaction])
abstract class AppDatabase extends FloorDatabase {
  NationalityDao get nationalityDao;

  TransferBeneficiaryDao get transferBeneficiaryDao;

  InstitutionDao get institutionDao;

  FeeVatConfigDao get feeVatConfigDao;

  TransferDao get transferDao;
}