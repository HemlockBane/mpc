// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moniepoint_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  NationalityDao? _nationalityDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `nationalities` (`id` INTEGER, `code` TEXT, `name` TEXT NOT NULL, `postCode` TEXT, `isoCode` TEXT, `base64Icon` TEXT, `active` INTEGER, `timeAdded` TEXT, `states` TEXT, `nationality` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NationalityDao get nationalityDao {
    return _nationalityDaoInstance ??=
        _$NationalityDao(database, changeListener);
  }
}

class _$NationalityDao extends NationalityDao {
  _$NationalityDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _nationalityInsertionAdapter = InsertionAdapter(
            database,
            'nationalities',
            (Nationality item) => <String, Object?>{
                  'id': item.id,
                  'code': item.code,
                  'name': item.name,
                  'postCode': item.postCode,
                  'isoCode': item.isoCode,
                  'base64Icon': item.base64Icon,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'timeAdded': item.timeAdded,
                  'states': _listConverter.encode(item.states),
                  'nationality': item.nationality
                }),
        _nationalityDeletionAdapter = DeletionAdapter(
            database,
            'nationalities',
            ['id'],
            (Nationality item) => <String, Object?>{
                  'id': item.id,
                  'code': item.code,
                  'name': item.name,
                  'postCode': item.postCode,
                  'isoCode': item.isoCode,
                  'base64Icon': item.base64Icon,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'timeAdded': item.timeAdded,
                  'states': _listConverter.encode(item.states),
                  'nationality': item.nationality
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Nationality> _nationalityInsertionAdapter;

  final DeletionAdapter<Nationality> _nationalityDeletionAdapter;

  @override
  Future<List<Nationality>> getNationalities() async {
    return _queryAdapter.queryList('SELECT * FROM nationalities',
        mapper: (Map<String, Object?> row) => Nationality(
            row['nationality'] as String?,
            row['id'] as int?,
            row['code'] as String?,
            row['name'] as String,
            row['postCode'] as String?,
            row['isoCode'] as String?,
            row['base64Icon'] as String?,
            row['active'] == null ? null : (row['active'] as int) != 0,
            row['timeAdded'] as String?,
            _listConverter.decode(row['states'] as String?)));
  }

  @override
  Future<void> insertItem(Nationality item) async {
    await _nationalityInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<Nationality> item) async {
    await _nationalityInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<Nationality> item) async {
    await _nationalityDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(Nationality item) async {
    await _nationalityDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _listConverter = ListConverter();
