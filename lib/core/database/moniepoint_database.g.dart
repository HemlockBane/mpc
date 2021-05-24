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

  TransferBeneficiaryDao? _transferBeneficiaryDaoInstance;

  InstitutionDao? _institutionDaoInstance;

  FeeVatConfigDao? _feeVatConfigDaoInstance;

  TransferDao? _transferDaoInstance;

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
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transfer_beneficiaries` (`accountName` TEXT NOT NULL, `accountNumber` TEXT NOT NULL, `bvn` TEXT, `nameEnquiryReference` TEXT, `accountProviderName` TEXT, `accountProviderCode` TEXT, `frequency` INTEGER, `lastUpdated` INTEGER, PRIMARY KEY (`accountName`, `accountNumber`, `accountProviderCode`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `account_providers` (`id` INTEGER, `name` TEXT, `bankCode` TEXT, `bankShortName` TEXT, `centralBankCode` TEXT, `aptentRoutingKey` TEXT, `customerRMNodeType` TEXT, `customerAccountRMNodeType` TEXT, `unsupportedFeatures` TEXT, `categoryId` TEXT, PRIMARY KEY (`bankCode`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `fee_vat_configs` (`id` INTEGER, `chargeType` TEXT NOT NULL, `minorFee` REAL, `minorVat` REAL, `boundedCharges` TEXT, PRIMARY KEY (`id`, `chargeType`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transfer_transactions` (`batch_id` INTEGER, `history_id` INTEGER, `batch` TEXT, `history` TEXT, `historyType` TEXT, `dateAdded` INTEGER, PRIMARY KEY (`batch_id`, `history_id`))');

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

  @override
  TransferBeneficiaryDao get transferBeneficiaryDao {
    return _transferBeneficiaryDaoInstance ??=
        _$TransferBeneficiaryDao(database, changeListener);
  }

  @override
  InstitutionDao get institutionDao {
    return _institutionDaoInstance ??=
        _$InstitutionDao(database, changeListener);
  }

  @override
  FeeVatConfigDao get feeVatConfigDao {
    return _feeVatConfigDaoInstance ??=
        _$FeeVatConfigDao(database, changeListener);
  }

  @override
  TransferDao get transferDao {
    return _transferDaoInstance ??= _$TransferDao(database, changeListener);
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
                  'states': _listStateConverter.encode(item.states),
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
                  'states': _listStateConverter.encode(item.states),
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
            _listStateConverter.decode(row['states'] as String?)));
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

class _$TransferBeneficiaryDao extends TransferBeneficiaryDao {
  _$TransferBeneficiaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _transferBeneficiaryInsertionAdapter = InsertionAdapter(
            database,
            'transfer_beneficiaries',
            (TransferBeneficiary item) => <String, Object?>{
                  'accountName': item.accountName,
                  'accountNumber': item.accountNumber,
                  'bvn': item.bvn,
                  'nameEnquiryReference': item.nameEnquiryReference,
                  'accountProviderName': item.accountProviderName,
                  'accountProviderCode': item.accountProviderCode,
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener),
        _transferBeneficiaryDeletionAdapter = DeletionAdapter(
            database,
            'transfer_beneficiaries',
            ['accountName', 'accountNumber', 'accountProviderCode'],
            (TransferBeneficiary item) => <String, Object?>{
                  'accountName': item.accountName,
                  'accountNumber': item.accountNumber,
                  'bvn': item.bvn,
                  'nameEnquiryReference': item.nameEnquiryReference,
                  'accountProviderName': item.accountProviderName,
                  'accountProviderCode': item.accountProviderCode,
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransferBeneficiary>
      _transferBeneficiaryInsertionAdapter;

  final DeletionAdapter<TransferBeneficiary>
      _transferBeneficiaryDeletionAdapter;

  @override
  Stream<List<TransferBeneficiary>> getFrequentBeneficiaries(int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_beneficiaries ORDER BY frequency DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => TransferBeneficiary(
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String,
            bvn: row['bvn'] as String?,
            nameEnquiryReference: row['nameEnquiryReference'] as String?,
            accountProviderName: row['accountProviderName'] as String?,
            accountProviderCode: row['accountProviderCode'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [limit],
        queryableName: 'transfer_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<TransferBeneficiary>> getPagedTransferBeneficiary() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_beneficiaries ORDER BY frequency DESC',
        mapper: (Map<String, Object?> row) => TransferBeneficiary(
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String,
            bvn: row['bvn'] as String?,
            nameEnquiryReference: row['nameEnquiryReference'] as String?,
            accountProviderName: row['accountProviderName'] as String?,
            accountProviderCode: row['accountProviderCode'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        queryableName: 'transfer_beneficiaries',
        isView: false);
  }

  @override
  Future<void> deleteAll(List<String> accountNumbers) async {
    const offset = 1;
    final _sqliteVariablesForAccountNumbers = Iterable<String>.generate(
        accountNumbers.length, (i) => '?${i + offset}').join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM transfer_beneficiaries WHERE accountNumber NOT IN(' +
            _sqliteVariablesForAccountNumbers +
            ')',
        arguments: [...accountNumbers]);
  }

  @override
  Future<void> insertItem(TransferBeneficiary item) async {
    await _transferBeneficiaryInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<TransferBeneficiary> item) async {
    await _transferBeneficiaryInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<TransferBeneficiary> item) async {
    await _transferBeneficiaryDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(TransferBeneficiary item) async {
    await _transferBeneficiaryDeletionAdapter.delete(item);
  }
}

class _$InstitutionDao extends InstitutionDao {
  _$InstitutionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _accountProviderInsertionAdapter = InsertionAdapter(
            database,
            'account_providers',
            (AccountProvider item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'bankCode': item.bankCode,
                  'bankShortName': item.bankShortName,
                  'centralBankCode': item.centralBankCode,
                  'aptentRoutingKey': item.aptentRoutingKey,
                  'customerRMNodeType': item.customerRMNodeType,
                  'customerAccountRMNodeType': item.customerAccountRMNodeType,
                  'unsupportedFeatures':
                      _listStringConverter.encode(item.unsupportedFeatures),
                  'categoryId': item.categoryId
                },
            changeListener),
        _accountProviderDeletionAdapter = DeletionAdapter(
            database,
            'account_providers',
            ['bankCode'],
            (AccountProvider item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'bankCode': item.bankCode,
                  'bankShortName': item.bankShortName,
                  'centralBankCode': item.centralBankCode,
                  'aptentRoutingKey': item.aptentRoutingKey,
                  'customerRMNodeType': item.customerRMNodeType,
                  'customerAccountRMNodeType': item.customerAccountRMNodeType,
                  'unsupportedFeatures':
                      _listStringConverter.encode(item.unsupportedFeatures),
                  'categoryId': item.categoryId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccountProvider> _accountProviderInsertionAdapter;

  final DeletionAdapter<AccountProvider> _accountProviderDeletionAdapter;

  @override
  Stream<List<AccountProvider>> getAccountProviders() {
    return _queryAdapter.queryListStream('SELECT * FROM account_providers',
        mapper: (Map<String, Object?> row) => AccountProvider(
            id: row['id'] as int?,
            name: row['name'] as String?,
            bankCode: row['bankCode'] as String?,
            bankShortName: row['bankShortName'] as String?,
            centralBankCode: row['centralBankCode'] as String?,
            aptentRoutingKey: row['aptentRoutingKey'] as String?,
            customerRMNodeType: row['customerRMNodeType'] as String?,
            customerAccountRMNodeType:
                row['customerAccountRMNodeType'] as String?,
            unsupportedFeatures: _listStringConverter
                .decode(row['unsupportedFeatures'] as String?),
            categoryId: row['categoryId'] as String?),
        queryableName: 'account_providers',
        isView: false);
  }

  @override
  Stream<List<AccountProvider>> searchPageAccountProviders(String search) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_providers WHERE name LIKE ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => AccountProvider(
            id: row['id'] as int?,
            name: row['name'] as String?,
            bankCode: row['bankCode'] as String?,
            bankShortName: row['bankShortName'] as String?,
            centralBankCode: row['centralBankCode'] as String?,
            aptentRoutingKey: row['aptentRoutingKey'] as String?,
            customerRMNodeType: row['customerRMNodeType'] as String?,
            customerAccountRMNodeType:
                row['customerAccountRMNodeType'] as String?,
            unsupportedFeatures: _listStringConverter
                .decode(row['unsupportedFeatures'] as String?),
            categoryId: row['categoryId'] as String?),
        arguments: [search],
        queryableName: 'account_providers',
        isView: false);
  }

  @override
  Stream<List<AccountProvider>> searchAccountProviders(
      int limit, String search) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_providers WHERE name LIKE ?2 ORDER BY name ASC LIMIT ?1',
        mapper: (Map<String, Object?> row) => AccountProvider(
            id: row['id'] as int?,
            name: row['name'] as String?,
            bankCode: row['bankCode'] as String?,
            bankShortName: row['bankShortName'] as String?,
            centralBankCode: row['centralBankCode'] as String?,
            aptentRoutingKey: row['aptentRoutingKey'] as String?,
            customerRMNodeType: row['customerRMNodeType'] as String?,
            customerAccountRMNodeType:
                row['customerAccountRMNodeType'] as String?,
            unsupportedFeatures: _listStringConverter
                .decode(row['unsupportedFeatures'] as String?),
            categoryId: row['categoryId'] as String?),
        arguments: [limit, search],
        queryableName: 'account_providers',
        isView: false);
  }

  @override
  Future<void> insertItem(AccountProvider item) async {
    await _accountProviderInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AccountProvider> item) async {
    await _accountProviderInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AccountProvider> item) async {
    await _accountProviderDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AccountProvider item) async {
    await _accountProviderDeletionAdapter.delete(item);
  }
}

class _$FeeVatConfigDao extends FeeVatConfigDao {
  _$FeeVatConfigDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _feeVatConfigInsertionAdapter = InsertionAdapter(
            database,
            'fee_vat_configs',
            (FeeVatConfig item) => <String, Object?>{
                  'id': item.id,
                  'chargeType': item.chargeType,
                  'minorFee': item.minorFee,
                  'minorVat': item.minorVat,
                  'boundedCharges':
                      _listBoundedChargesConverter.encode(item.boundedCharges)
                },
            changeListener),
        _feeVatConfigDeletionAdapter = DeletionAdapter(
            database,
            'fee_vat_configs',
            ['id', 'chargeType'],
            (FeeVatConfig item) => <String, Object?>{
                  'id': item.id,
                  'chargeType': item.chargeType,
                  'minorFee': item.minorFee,
                  'minorVat': item.minorVat,
                  'boundedCharges':
                      _listBoundedChargesConverter.encode(item.boundedCharges)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FeeVatConfig> _feeVatConfigInsertionAdapter;

  final DeletionAdapter<FeeVatConfig> _feeVatConfigDeletionAdapter;

  @override
  Stream<FeeVatConfig?> getFeeAndVatConfigByType() {
    return _queryAdapter.queryStream(
        'SELECT * FROM fee_vat_configs WHERE chargeType ="BOUNDED"',
        mapper: (Map<String, Object?> row) => FeeVatConfig(
            id: row['id'] as int?,
            chargeType: row['chargeType'] as String,
            minorFee: row['minorFee'] as double?,
            minorVat: row['minorVat'] as double?,
            boundedCharges: _listBoundedChargesConverter
                .decode(row['boundedCharges'] as String?)),
        queryableName: 'fee_vat_configs',
        isView: false);
  }

  @override
  Future<void> deleteAllConfig() async {
    await _queryAdapter.queryNoReturn('DELETE FROM fee_vat_configs');
  }

  @override
  Future<void> insertItem(FeeVatConfig item) async {
    await _feeVatConfigInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<FeeVatConfig> item) async {
    await _feeVatConfigInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<FeeVatConfig> item) async {
    await _feeVatConfigDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(FeeVatConfig item) async {
    await _feeVatConfigDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteAndInsert(List<FeeVatConfig> items) async {
    if (database is sqflite.Transaction) {
      await super.deleteAndInsert(items);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.feeVatConfigDao.deleteAndInsert(items);
      });
    }
  }
}

class _$TransferDao extends TransferDao {
  _$TransferDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _singleTransferTransactionInsertionAdapter = InsertionAdapter(
            database,
            'transfer_transactions',
            (SingleTransferTransaction item) => <String, Object?>{
                  'batch_id': item.batchId,
                  'history_id': item.historyId,
                  'batch': _transferBatchConverter.encode(item.transferBatch),
                  'history':
                      _transferHistoryItemConverter.encode(item.transfer),
                  'historyType': item.historyType,
                  'dateAdded': item.historyDateAdded
                },
            changeListener),
        _singleTransferTransactionDeletionAdapter = DeletionAdapter(
            database,
            'transfer_transactions',
            ['batch_id', 'history_id'],
            (SingleTransferTransaction item) => <String, Object?>{
                  'batch_id': item.batchId,
                  'history_id': item.historyId,
                  'batch': _transferBatchConverter.encode(item.transferBatch),
                  'history':
                      _transferHistoryItemConverter.encode(item.transfer),
                  'historyType': item.historyType,
                  'dateAdded': item.historyDateAdded
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SingleTransferTransaction>
      _singleTransferTransactionInsertionAdapter;

  final DeletionAdapter<SingleTransferTransaction>
      _singleTransferTransactionDeletionAdapter;

  @override
  Stream<List<SingleTransferTransaction>> getSingleTransferTransactions(
      int startDate, int endDate) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_transactions WHERE (dateAdded BETWEEN ?1 AND ?2) ORDER BY dateAdded DESC',
        mapper: (Map<String, Object?> row) => SingleTransferTransaction(
            batchId: row['batch_id'] as int?,
            historyId: row['history_id'] as int?,
            transferBatch:
                _transferBatchConverter.decode(row['batch'] as String?),
            transfer:
                _transferHistoryItemConverter.decode(row['history'] as String?),
            historyType: row['historyType'] as String?,
            historyDateAdded: row['dateAdded'] as int?),
        arguments: [startDate, endDate],
        queryableName: 'transfer_transactions',
        isView: false);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM transfer_transactions');
  }

  @override
  Future<void> insertItem(SingleTransferTransaction item) async {
    await _singleTransferTransactionInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<SingleTransferTransaction> item) async {
    await _singleTransferTransactionInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<SingleTransferTransaction> item) async {
    await _singleTransferTransactionDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(SingleTransferTransaction item) async {
    await _singleTransferTransactionDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _listStateConverter = ListStateConverter();
final _listStringConverter = ListStringConverter();
final _listBoundedChargesConverter = ListBoundedChargesConverter();
final _transferBatchConverter = TransferBatchConverter();
final _transferHistoryItemConverter = TransferHistoryItemConverter();
