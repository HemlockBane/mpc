import 'package:floor/floor.dart';

class AppMigration {

  List<Migration> getMigrations() {
      return [
        _version1To2()
      ];
  }

  Migration _version1To2() {
    return Migration(1, 2, (db) async {
      print("MMMMMMMiiiiigggrrrrrrrrraaaaaaattttttttiiiiiiinnnnggggg");
      // await db.execute('ALTER TABLE bill_transactions ADD COLUMN nickname TEXT');
    });
  }

}