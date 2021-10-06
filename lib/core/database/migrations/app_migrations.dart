import 'package:floor/floor.dart';

class AppMigration {

  List<Migration> getMigrations() {
      return [
        _version1To2(),
        _version2To3()
      ];
  }

  Migration _version1To2() {
    return Migration(1, 2, (db) async {
      await db.execute('ALTER TABLE account_transactions ADD COLUMN customerAccountId INT');
    });
  }

  Migration _version2To3() {
    return Migration(2, 3, (db) async {
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
    });
  }

}