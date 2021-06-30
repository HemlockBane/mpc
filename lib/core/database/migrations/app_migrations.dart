import 'package:floor/floor.dart';

class AppMigration {

  List<Migration> getMigrations() {
      return [
        _version1To2()
      ];
  }

  Migration _version1To2() {
    return Migration(1, 2, (db) async {
      await db.execute('ALTER TABLE account_transactions ADD COLUMN customerAccountId INT');
    });
  }

}