import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';

class AppMigration {

  List<Migration> getMigrations() {
      return [
        _version1To2(),
        _version2To3(),
        _version3To4(),
        _version4To5(),
        _version5To6(),
        _version6To7()
      ];
  }

  Migration _version1To2() {
    return Migration(1, 2, (db) async {
      await db.execute('ALTER TABLE account_transactions ADD COLUMN customerAccountId INT');
    });
  }

  Migration _version2To3() {
    return Migration(2, 3, (db) async {
      print("Run Migrations.....");

      await db.execute('ALTER TABLE account_transactions ADD COLUMN transactionCategory VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN transactionCode VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN beneficiaryIdentifier VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN beneficiaryName VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN beneficiaryBankName VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN beneficiaryBankCode VARCHAR');

      await db.execute('ALTER TABLE account_transactions ADD COLUMN senderIdentifier VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN senderName VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN senderBankName VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN senderBankCode VARCHAR');

      await db.execute('ALTER TABLE account_transactions ADD COLUMN providerIdentifier VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN providerName VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN transactionIdentifier VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN merchantLocation VARCHAR');

      await db.execute('ALTER TABLE account_transactions ADD COLUMN cardScheme VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN maskedPan VARCHAR');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN disputable INT');
      await db.execute('ALTER TABLE account_transactions ADD COLUMN terminalID VARCHAR');

      await db.execute('ALTER TABLE account_transactions ADD COLUMN location VARCHAR');
      print("Ending Run Migrations.....");
    });
  }

  Migration _version3To4() {
    return Migration(3, 4, (db) async {
      print(".....Run Migrations.....");
      await db.execute('ALTER TABLE biller_products ADD COLUMN billerName VARCHAR');
      print(".....Ending Run Migrations.....");
    });
  }

  Migration _version4To5() {
    return Migration(4, 5, (db) async {
      print(".....Run Migrations.....");
      await db.execute('DROP TABLE bill_transactions');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS bill_transactions ('
            'id INTEGER PRIMARY KEY, minorAmount INTEGER, sourceAccountProviderName VARCHAR,'
            'sourceAccountNumber VARCHAR, sourceAccountCurrencyCode VARCHAR,'
            'transactionStatus VARCHAR, transactionTime INTEGER, customerId VARCHAR, '
            'customerIdName VARCHAR, billerCategoryName VARCHAR, billerCategoryCode VARCHAR,'
            'billerName VARCHAR, billerCode VARCHAR, billerLogoUUID VARCHAR, billerProductName VARCHAR,'
            'billerProductCode VARCHAR, transactionId VARCHAR, token VARCHAR'
          ')'
      );
      print(".....Ending Run Migrations.....");
    });
  }

  Migration _version5To6() {
    return Migration(5, 6, (db) async {
      print(".....Run Migrations.....");
      print(".....Ending Run Migrations.....");
    });
  }

  Migration _version6To7() {
    return Migration(6, 7, (db) async {
      print(".....Run Migrations.....");
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $FLEX_SAVING_TABLE ('
              'id INTEGER PRIMARY KEY, createdOn INTEGER, '
              'flexVersion VARCHAR, cbaAccountNuban VARCHAR,'
              'flexSavingScheme VARCHAR, flexSavingInterestProfile VARCHAR,'
              'configCreated INT, flexSavingConfigId INTEGER, `flexSavingName` VARCHAR'
              ')'
      );

      await db.execute(
          'CREATE TABLE IF NOT EXISTS $FLEX_TRANSACTION_TABLE ('
              'transactionRef VARCHAR PRIMARY KEY, transactionDate INTEGER, accountNumber VARCHAR,'
              'status VARCHAR, amount REAL, type VARCHAR, transactionChannel VARCHAR,'
              'tags VARCHAR, narration VARCHAR, runningBalance VARCHAR, '
              'balanceBefore VARCHAR, balanceAfter VARCHAR, '
              'transactionCategory VARCHAR, transactionCode VARCHAR, beneficiaryIdentifier VARCHAR,'
              'beneficiaryName VARCHAR, beneficiaryBankName VARCHAR, beneficiaryBankCode VARCHAR,'
              'senderIdentifier VARCHAR, senderName VARCHAR, senderBankName VARCHAR, senderBankCode VARCHAR,'
              'providerIdentifier VARCHAR, providerName VARCHAR, transactionIdentifier VARCHAR,'
              'merchantLocation VARCHAR, cardScheme VARCHAR, maskedPan VARCHAR, terminalID VARCHAR, disputable INT,'
              'metaData VARCHAR, location VARCHAR, flexSavingId INTEGER'
          ')'
      );
      print(".....Ending Run Migrations.....");
    });
  }

}