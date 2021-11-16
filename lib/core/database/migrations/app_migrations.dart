import 'package:floor/floor.dart';

class AppMigration {

  List<Migration> getMigrations() {
      return [
        _version1To2(),
        _version2To3(),
        _version3To4()
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
      print("Run Migrations.....");
      await db.execute('ALTER TABLE biller_products ADD COLUMN billerName VARCHAR');
      print("Ending Run Migrations.....");
    });
  }

}