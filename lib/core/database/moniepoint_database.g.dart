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

  AirtimeDao? _airtimeDaoInstance;

  AirtimeBeneficiaryDao? _airtimeBeneficiaryDaoInstance;

  AirtimeServiceProviderDao? _serviceProviderDaoInstance;

  AirtimeServiceProviderItemDao? _serviceProviderItemDaoInstance;

  BillsDao? _billsDaoInstance;

  BillBeneficiaryDao? _billBeneficiaryDaoInstance;

  BillerDao? _billerDaoInstance;

  BillerCategoryDao? _billerCategoryDaoInstance;

  BillerProductDao? _billerProductDaoInstance;

  TransactionDao? _transactionDaoInstance;

  SchemeDao? _schemeDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 5,
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
            'CREATE TABLE IF NOT EXISTS `transfer_beneficiaries` (`id` INTEGER, `accountName` TEXT NOT NULL, `accountNumber` TEXT NOT NULL, `bvn` TEXT, `nameEnquiryReference` TEXT, `accountProviderName` TEXT, `accountProviderCode` TEXT, `frequency` INTEGER, `lastUpdated` INTEGER, PRIMARY KEY (`accountName`, `accountNumber`, `accountProviderCode`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `account_providers` (`id` INTEGER, `name` TEXT, `bankCode` TEXT, `bankShortName` TEXT, `centralBankCode` TEXT, `aptentRoutingKey` TEXT, `customerRMNodeType` TEXT, `customerAccountRMNodeType` TEXT, `unsupportedFeatures` TEXT, `categoryId` TEXT, PRIMARY KEY (`bankCode`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `fee_vat_configs` (`id` INTEGER, `chargeType` TEXT NOT NULL, `minorFee` REAL, `minorVat` REAL, `boundedCharges` TEXT, PRIMARY KEY (`id`, `chargeType`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transfer_transactions` (`batch_id` INTEGER, `history_id` INTEGER, `batch` TEXT, `history` TEXT, `historyType` TEXT, `dateAdded` INTEGER, PRIMARY KEY (`batch_id`, `history_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `airtime_transactions` (`username` TEXT, `batch_id` INTEGER NOT NULL, `history_id` INTEGER NOT NULL, `batch` TEXT, `history` TEXT, `historyType` TEXT, `creationTimeStamp` INTEGER, PRIMARY KEY (`batch_id`, `history_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `airtime_beneficiaries` (`id` INTEGER NOT NULL, `name` TEXT, `phoneNumber` TEXT, `serviceProvider` TEXT, `frequency` INTEGER, `lastUpdated` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `service_providers` (`code` TEXT NOT NULL, `name` TEXT, `currencySymbol` TEXT, `billerId` TEXT, `identifierName` TEXT, `svgImage` TEXT, `logoImageUUID` TEXT, PRIMARY KEY (`code`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `service_provider_items` (`id` INTEGER NOT NULL, `active` INTEGER, `amount` INTEGER, `code` TEXT, `currencySymbol` TEXT, `fee` REAL, `name` TEXT, `paymentCode` TEXT, `priceFixed` INTEGER, `billerId` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bill_transactions` (`id` INTEGER, `minorAmount` INTEGER, `sourceAccountProviderName` TEXT, `sourceAccountNumber` TEXT, `sourceAccountCurrencyCode` TEXT, `transactionStatus` TEXT, `transactionTime` INTEGER, `customerId` TEXT, `customerIdName` TEXT, `billerCategoryName` TEXT, `billerCategoryCode` TEXT, `billerName` TEXT, `billerCode` TEXT, `billerLogoUUID` TEXT, `billerProductName` TEXT, `billerProductCode` TEXT, `transactionId` TEXT, `token` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `bill_beneficiaries` (`id` INTEGER NOT NULL, `name` TEXT, `billerCode` TEXT, `billerCategoryLogo` TEXT, `biller` TEXT, `billerProducts` TEXT, `billerName` TEXT, `customerIdentity` TEXT, `frequency` INTEGER, `lastUpdated` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `billers` (`billerCategoryId` TEXT, `billerCategoryCode` TEXT, `id` INTEGER NOT NULL, `name` TEXT, `code` TEXT, `identifierName` TEXT, `currencySymbol` TEXT, `active` INTEGER, `collectionAccountNumber` TEXT, `collectionAccountName` TEXT, `collectionAccountProviderCode` TEXT, `collectionAccountProviderName` TEXT, `svgImage` TEXT, `logoImageUUID` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `biller_categories` (`id` INTEGER NOT NULL, `name` TEXT, `description` TEXT, `categoryCode` TEXT, `active` INTEGER, `svgImage` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `biller_products` (`billerCode` TEXT, `id` INTEGER NOT NULL, `name` TEXT, `code` TEXT, `amount` REAL, `fee` REAL, `paymentCode` TEXT, `currencySymbol` TEXT, `active` INTEGER, `priceFixed` INTEGER, `minimumAmount` REAL, `maximumAmount` REAL, `identifierName` TEXT, `additionalFieldsMap` TEXT, `billerName` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `account_transactions` (`id` INTEGER, `accountNumber` TEXT, `status` INTEGER, `transactionRef` TEXT NOT NULL, `amount` REAL, `type` TEXT, `transactionChannel` TEXT, `tags` TEXT, `narration` TEXT, `transactionDate` INTEGER NOT NULL, `runningBalance` TEXT, `balanceBefore` TEXT, `balanceAfter` TEXT, `transactionCategory` TEXT, `transactionCode` TEXT, `beneficiaryIdentifier` TEXT, `beneficiaryName` TEXT, `beneficiaryBankName` TEXT, `beneficiaryBankCode` TEXT, `senderIdentifier` TEXT, `senderName` TEXT, `senderBankName` TEXT, `senderBankCode` TEXT, `providerIdentifier` TEXT, `providerName` TEXT, `transactionIdentifier` TEXT, `merchantLocation` TEXT, `cardScheme` TEXT, `maskedPan` TEXT, `terminalID` TEXT, `disputable` INTEGER, `location` TEXT, `metaData` TEXT, `customerAccountId` INTEGER, PRIMARY KEY (`transactionRef`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tiers` (`id` INTEGER NOT NULL, `status` TEXT, `createdOn` TEXT, `lastModifiedOn` TEXT, `code` TEXT, `name` TEXT, `classification` TEXT, `accountNumberPrefix` TEXT, `accountNumberLength` INTEGER, `allowNegativeBalance` INTEGER, `allowLien` INTEGER, `enableInstantBalanceUpdate` INTEGER, `maximumCumulativeBalance` REAL, `maximumSingleDebit` REAL, `maximumSingleCredit` REAL, `maximumDailyDebit` REAL, `maximumDailyCredit` REAL, `schemeRequirement` TEXT, `alternateSchemeRequirement` TEXT, `supportsAccountGeneration` INTEGER, PRIMARY KEY (`id`))');

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

  @override
  AirtimeDao get airtimeDao {
    return _airtimeDaoInstance ??= _$AirtimeDao(database, changeListener);
  }

  @override
  AirtimeBeneficiaryDao get airtimeBeneficiaryDao {
    return _airtimeBeneficiaryDaoInstance ??=
        _$AirtimeBeneficiaryDao(database, changeListener);
  }

  @override
  AirtimeServiceProviderDao get serviceProviderDao {
    return _serviceProviderDaoInstance ??=
        _$AirtimeServiceProviderDao(database, changeListener);
  }

  @override
  AirtimeServiceProviderItemDao get serviceProviderItemDao {
    return _serviceProviderItemDaoInstance ??=
        _$AirtimeServiceProviderItemDao(database, changeListener);
  }

  @override
  BillsDao get billsDao {
    return _billsDaoInstance ??= _$BillsDao(database, changeListener);
  }

  @override
  BillBeneficiaryDao get billBeneficiaryDao {
    return _billBeneficiaryDaoInstance ??=
        _$BillBeneficiaryDao(database, changeListener);
  }

  @override
  BillerDao get billerDao {
    return _billerDaoInstance ??= _$BillerDao(database, changeListener);
  }

  @override
  BillerCategoryDao get billerCategoryDao {
    return _billerCategoryDaoInstance ??=
        _$BillerCategoryDao(database, changeListener);
  }

  @override
  BillerProductDao get billerProductDao {
    return _billerProductDaoInstance ??=
        _$BillerProductDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  SchemeDao get schemeDao {
    return _schemeDaoInstance ??= _$SchemeDao(database, changeListener);
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
                  'id': item.id,
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
                  'id': item.id,
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
            id: row['id'] as int?,
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
  Stream<List<TransferBeneficiary>> getPagedTransferBeneficiary(
      int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_beneficiaries ORDER BY accountName ASC LIMIT ?2 OFFSET ?1',
        mapper: (Map<String, Object?> row) => TransferBeneficiary(
            id: row['id'] as int?,
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String,
            bvn: row['bvn'] as String?,
            nameEnquiryReference: row['nameEnquiryReference'] as String?,
            accountProviderName: row['accountProviderName'] as String?,
            accountProviderCode: row['accountProviderCode'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [myOffset, limit],
        queryableName: 'transfer_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<TransferBeneficiary>> searchPagedTransferBeneficiary(
      String search, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_beneficiaries WHERE accountName LIKE ?1 OR accountNumber LIKE ?1 ORDER BY accountName ASC LIMIT ?3 OFFSET ?2',
        mapper: (Map<String, Object?> row) => TransferBeneficiary(
            id: row['id'] as int?,
            accountName: row['accountName'] as String,
            accountNumber: row['accountNumber'] as String,
            bvn: row['bvn'] as String?,
            nameEnquiryReference: row['nameEnquiryReference'] as String?,
            accountProviderName: row['accountProviderName'] as String?,
            accountProviderCode: row['accountProviderCode'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [search, myOffset, limit],
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
        'SELECT * FROM account_providers WHERE name LIKE ?1 OR bankShortName LIKE ?1 ORDER BY name ASC',
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
        'SELECT * FROM account_providers WHERE name LIKE ?2 OR bankShortName LIKE ?2 ORDER BY name ASC LIMIT ?1',
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
      int startDate, int endDate, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transfer_transactions WHERE (dateAdded BETWEEN ?1 AND ?2) ORDER BY dateAdded DESC LIMIT ?4 OFFSET ?3',
        mapper: (Map<String, Object?> row) => SingleTransferTransaction(
            batchId: row['batch_id'] as int?,
            historyId: row['history_id'] as int?,
            transferBatch:
                _transferBatchConverter.decode(row['batch'] as String?),
            transfer:
                _transferHistoryItemConverter.decode(row['history'] as String?),
            historyType: row['historyType'] as String?,
            historyDateAdded: row['dateAdded'] as int?),
        arguments: [startDate, endDate, myOffset, limit],
        queryableName: 'transfer_transactions',
        isView: false);
  }

  @override
  Future<SingleTransferTransaction?> getSingleTransferTransactionById(
      int id) async {
    return _queryAdapter.query(
        'SELECT * FROM transfer_transactions WHERE history_id = ?1',
        mapper: (Map<String, Object?> row) => SingleTransferTransaction(
            batchId: row['batch_id'] as int?,
            historyId: row['history_id'] as int?,
            transferBatch:
                _transferBatchConverter.decode(row['batch'] as String?),
            transfer:
                _transferHistoryItemConverter.decode(row['history'] as String?),
            historyType: row['historyType'] as String?,
            historyDateAdded: row['dateAdded'] as int?),
        arguments: [id]);
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

class _$AirtimeDao extends AirtimeDao {
  _$AirtimeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _airtimeTransactionInsertionAdapter = InsertionAdapter(
            database,
            'airtime_transactions',
            (AirtimeTransaction item) => <String, Object?>{
                  'username': item.username,
                  'batch_id': item.batchId,
                  'history_id': item.historyId,
                  'batch': _transactionBatchConverter
                      .encode(item.institutionAirtime),
                  'history': _airtimeHistoryItemConverter.encode(item.request),
                  'historyType': item.historyType,
                  'creationTimeStamp': item.creationTimeStamp
                },
            changeListener),
        _airtimeTransactionDeletionAdapter = DeletionAdapter(
            database,
            'airtime_transactions',
            ['batch_id', 'history_id'],
            (AirtimeTransaction item) => <String, Object?>{
                  'username': item.username,
                  'batch_id': item.batchId,
                  'history_id': item.historyId,
                  'batch': _transactionBatchConverter
                      .encode(item.institutionAirtime),
                  'history': _airtimeHistoryItemConverter.encode(item.request),
                  'historyType': item.historyType,
                  'creationTimeStamp': item.creationTimeStamp
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirtimeTransaction>
      _airtimeTransactionInsertionAdapter;

  final DeletionAdapter<AirtimeTransaction> _airtimeTransactionDeletionAdapter;

  @override
  Stream<List<AirtimeTransaction>> getAirtimeTransactions(
      int startDate, int endDate, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM airtime_transactions WHERE (creationTimeStamp BETWEEN ?1 AND ?2) ORDER BY creationTimeStamp DESC LIMIT ?4 OFFSET ?3',
        mapper: (Map<String, Object?> row) => AirtimeTransaction(
            batchId: row['batch_id'] as int,
            historyId: row['history_id'] as int,
            request:
                _airtimeHistoryItemConverter.decode(row['history'] as String?),
            username: row['username'] as String?,
            institutionAirtime:
                _transactionBatchConverter.decode(row['batch'] as String?),
            historyType: row['historyType'] as String?,
            creationTimeStamp: row['creationTimeStamp'] as int?),
        arguments: [startDate, endDate, myOffset, limit],
        queryableName: 'airtime_transactions',
        isView: false);
  }

  @override
  Future<AirtimeTransaction?> getAirtimeTransactionById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM airtime_transactions WHERE history_id =?1',
        mapper: (Map<String, Object?> row) => AirtimeTransaction(
            batchId: row['batch_id'] as int,
            historyId: row['history_id'] as int,
            request:
                _airtimeHistoryItemConverter.decode(row['history'] as String?),
            username: row['username'] as String?,
            institutionAirtime:
                _transactionBatchConverter.decode(row['batch'] as String?),
            historyType: row['historyType'] as String?,
            creationTimeStamp: row['creationTimeStamp'] as int?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM airtime_transactions');
  }

  @override
  Future<void> insertItem(AirtimeTransaction item) async {
    await _airtimeTransactionInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AirtimeTransaction> item) async {
    await _airtimeTransactionInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AirtimeTransaction> item) async {
    await _airtimeTransactionDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AirtimeTransaction item) async {
    await _airtimeTransactionDeletionAdapter.delete(item);
  }
}

class _$AirtimeBeneficiaryDao extends AirtimeBeneficiaryDao {
  _$AirtimeBeneficiaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _airtimeBeneficiaryInsertionAdapter = InsertionAdapter(
            database,
            'airtime_beneficiaries',
            (AirtimeBeneficiary item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'phoneNumber': item.phoneNumber,
                  'serviceProvider': _airtimeServiceProviderConverter
                      .encode(item.serviceProvider),
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener),
        _airtimeBeneficiaryDeletionAdapter = DeletionAdapter(
            database,
            'airtime_beneficiaries',
            ['id'],
            (AirtimeBeneficiary item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'phoneNumber': item.phoneNumber,
                  'serviceProvider': _airtimeServiceProviderConverter
                      .encode(item.serviceProvider),
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirtimeBeneficiary>
      _airtimeBeneficiaryInsertionAdapter;

  final DeletionAdapter<AirtimeBeneficiary> _airtimeBeneficiaryDeletionAdapter;

  @override
  Stream<List<AirtimeBeneficiary>> getFrequentBeneficiaries(int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => AirtimeBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            serviceProvider: _airtimeServiceProviderConverter
                .decode(row['serviceProvider'] as String?),
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [limit],
        queryableName: 'airtime_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<AirtimeBeneficiary>> getPagedAirtimeBeneficiary(
      int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT ?2 OFFSET ?1',
        mapper: (Map<String, Object?> row) => AirtimeBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            serviceProvider: _airtimeServiceProviderConverter
                .decode(row['serviceProvider'] as String?),
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [myOffset, limit],
        queryableName: 'airtime_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<AirtimeBeneficiary>> searchPagedAirtimeBeneficiary(
      String search, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM airtime_beneficiaries WHERE name LIKE ?1 OR phoneNumber LIKE ?1 ORDER BY name ASC LIMIT ?3 OFFSET ?2',
        mapper: (Map<String, Object?> row) => AirtimeBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            phoneNumber: row['phoneNumber'] as String?,
            serviceProvider: _airtimeServiceProviderConverter
                .decode(row['serviceProvider'] as String?),
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [search, myOffset, limit],
        queryableName: 'airtime_beneficiaries',
        isView: false);
  }

  @override
  Future<void> deleteAll(List<String> phoneNumbers) async {
    const offset = 1;
    final _sqliteVariablesForPhoneNumbers =
        Iterable<String>.generate(phoneNumbers.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM airtime_beneficiaries WHERE phoneNumber NOT IN(' +
            _sqliteVariablesForPhoneNumbers +
            ')',
        arguments: [...phoneNumbers]);
  }

  @override
  Future<void> insertItem(AirtimeBeneficiary item) async {
    await _airtimeBeneficiaryInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AirtimeBeneficiary> item) async {
    await _airtimeBeneficiaryInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AirtimeBeneficiary> item) async {
    await _airtimeBeneficiaryDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AirtimeBeneficiary item) async {
    await _airtimeBeneficiaryDeletionAdapter.delete(item);
  }
}

class _$AirtimeServiceProviderDao extends AirtimeServiceProviderDao {
  _$AirtimeServiceProviderDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _airtimeServiceProviderInsertionAdapter = InsertionAdapter(
            database,
            'service_providers',
            (AirtimeServiceProvider item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'currencySymbol': item.currencySymbol,
                  'billerId': item.billerId,
                  'identifierName': item.identifierName,
                  'svgImage': item.svgImage,
                  'logoImageUUID': item.logoImageUUID
                },
            changeListener),
        _airtimeServiceProviderDeletionAdapter = DeletionAdapter(
            database,
            'service_providers',
            ['code'],
            (AirtimeServiceProvider item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'currencySymbol': item.currencySymbol,
                  'billerId': item.billerId,
                  'identifierName': item.identifierName,
                  'svgImage': item.svgImage,
                  'logoImageUUID': item.logoImageUUID
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirtimeServiceProvider>
      _airtimeServiceProviderInsertionAdapter;

  final DeletionAdapter<AirtimeServiceProvider>
      _airtimeServiceProviderDeletionAdapter;

  @override
  Stream<List<AirtimeServiceProvider>> getAirtimeServiceProviders() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM service_providers ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => AirtimeServiceProvider(
            code: row['code'] as String,
            name: row['name'] as String?,
            currencySymbol: row['currencySymbol'] as String?,
            billerId: row['billerId'] as String?,
            identifierName: row['identifierName'] as String?,
            svgImage: row['svgImage'] as String?,
            logoImageUUID: row['logoImageUUID'] as String?),
        queryableName: 'service_providers',
        isView: false);
  }

  @override
  Future<void> insertItem(AirtimeServiceProvider item) async {
    await _airtimeServiceProviderInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AirtimeServiceProvider> item) async {
    await _airtimeServiceProviderInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AirtimeServiceProvider> item) async {
    await _airtimeServiceProviderDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AirtimeServiceProvider item) async {
    await _airtimeServiceProviderDeletionAdapter.delete(item);
  }
}

class _$AirtimeServiceProviderItemDao extends AirtimeServiceProviderItemDao {
  _$AirtimeServiceProviderItemDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _airtimeServiceProviderItemInsertionAdapter = InsertionAdapter(
            database,
            'service_provider_items',
            (AirtimeServiceProviderItem item) => <String, Object?>{
                  'id': item.id,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'amount': item.amount,
                  'code': item.code,
                  'currencySymbol': item.currencySymbol,
                  'fee': item.fee,
                  'name': item.name,
                  'paymentCode': item.paymentCode,
                  'priceFixed': item.priceFixed == null
                      ? null
                      : (item.priceFixed! ? 1 : 0),
                  'billerId': item.billerId
                },
            changeListener),
        _airtimeServiceProviderItemDeletionAdapter = DeletionAdapter(
            database,
            'service_provider_items',
            ['id'],
            (AirtimeServiceProviderItem item) => <String, Object?>{
                  'id': item.id,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'amount': item.amount,
                  'code': item.code,
                  'currencySymbol': item.currencySymbol,
                  'fee': item.fee,
                  'name': item.name,
                  'paymentCode': item.paymentCode,
                  'priceFixed': item.priceFixed == null
                      ? null
                      : (item.priceFixed! ? 1 : 0),
                  'billerId': item.billerId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirtimeServiceProviderItem>
      _airtimeServiceProviderItemInsertionAdapter;

  final DeletionAdapter<AirtimeServiceProviderItem>
      _airtimeServiceProviderItemDeletionAdapter;

  @override
  Stream<List<AirtimeServiceProviderItem>> getServiceProviderItems(
      String billerId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM service_provider_items WHERE billerId=?1',
        mapper: (Map<String, Object?> row) => AirtimeServiceProviderItem(
            id: row['id'] as int,
            active: row['active'] == null ? null : (row['active'] as int) != 0,
            amount: row['amount'] as int?,
            code: row['code'] as String?,
            currencySymbol: row['currencySymbol'] as String?,
            fee: row['fee'] as double?,
            name: row['name'] as String?,
            paymentCode: row['paymentCode'] as String?,
            priceFixed: row['priceFixed'] == null
                ? null
                : (row['priceFixed'] as int) != 0,
            billerId: row['billerId'] as String?),
        arguments: [billerId],
        queryableName: 'service_provider_items',
        isView: false);
  }

  @override
  Future<void> deleteProviderItemsByBillerId(
      String billerId, List<String> codes) async {
    const offset = 2;
    final _sqliteVariablesForCodes =
        Iterable<String>.generate(codes.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM service_provider_items WHERE billerId=?1 AND paymentCode NOT IN(' +
            _sqliteVariablesForCodes +
            ')',
        arguments: [billerId, ...codes]);
  }

  @override
  Future<void> insertItem(AirtimeServiceProviderItem item) async {
    await _airtimeServiceProviderItemInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AirtimeServiceProviderItem> item) async {
    await _airtimeServiceProviderItemInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AirtimeServiceProviderItem> item) async {
    await _airtimeServiceProviderItemDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AirtimeServiceProviderItem item) async {
    await _airtimeServiceProviderItemDeletionAdapter.delete(item);
  }
}

class _$BillsDao extends BillsDao {
  _$BillsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _billTransactionInsertionAdapter = InsertionAdapter(
            database,
            'bill_transactions',
            (BillTransaction item) => <String, Object?>{
                  'id': item.id,
                  'minorAmount': item.minorAmount,
                  'sourceAccountProviderName': item.sourceAccountProviderName,
                  'sourceAccountNumber': item.sourceAccountNumber,
                  'sourceAccountCurrencyCode': item.sourceAccountCurrencyCode,
                  'transactionStatus': item.transactionStatus,
                  'transactionTime': item.transactionTime,
                  'customerId': item.customerId,
                  'customerIdName': item.customerIdName,
                  'billerCategoryName': item.billerCategoryName,
                  'billerCategoryCode': item.billerCategoryCode,
                  'billerName': item.billerName,
                  'billerCode': item.billerCode,
                  'billerLogoUUID': item.billerLogoUUID,
                  'billerProductName': item.billerProductName,
                  'billerProductCode': item.billerProductCode,
                  'transactionId': item.transactionId,
                  'token': item.token
                },
            changeListener),
        _billTransactionDeletionAdapter = DeletionAdapter(
            database,
            'bill_transactions',
            ['id'],
            (BillTransaction item) => <String, Object?>{
                  'id': item.id,
                  'minorAmount': item.minorAmount,
                  'sourceAccountProviderName': item.sourceAccountProviderName,
                  'sourceAccountNumber': item.sourceAccountNumber,
                  'sourceAccountCurrencyCode': item.sourceAccountCurrencyCode,
                  'transactionStatus': item.transactionStatus,
                  'transactionTime': item.transactionTime,
                  'customerId': item.customerId,
                  'customerIdName': item.customerIdName,
                  'billerCategoryName': item.billerCategoryName,
                  'billerCategoryCode': item.billerCategoryCode,
                  'billerName': item.billerName,
                  'billerCode': item.billerCode,
                  'billerLogoUUID': item.billerLogoUUID,
                  'billerProductName': item.billerProductName,
                  'billerProductCode': item.billerProductCode,
                  'transactionId': item.transactionId,
                  'token': item.token
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BillTransaction> _billTransactionInsertionAdapter;

  final DeletionAdapter<BillTransaction> _billTransactionDeletionAdapter;

  @override
  Stream<List<BillTransaction>> getBillTransactions(
      int startDate, int endDate, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM bill_transactions WHERE (transactionTime BETWEEN ?1 AND ?2) AND transactionStatus != "CANCELLED" ORDER BY transactionTime DESC LIMIT ?4 OFFSET ?3',
        mapper: (Map<String, Object?> row) => BillTransaction(
            id: row['id'] as int?,
            minorAmount: row['minorAmount'] as int?,
            sourceAccountProviderName:
                row['sourceAccountProviderName'] as String?,
            sourceAccountNumber: row['sourceAccountNumber'] as String?,
            sourceAccountCurrencyCode:
                row['sourceAccountCurrencyCode'] as String?,
            transactionStatus: row['transactionStatus'] as String?,
            transactionTime: row['transactionTime'] as int?,
            customerId: row['customerId'] as String?,
            customerIdName: row['customerIdName'] as String?,
            billerCategoryName: row['billerCategoryName'] as String?,
            billerCategoryCode: row['billerCategoryCode'] as String?,
            billerName: row['billerName'] as String?,
            billerCode: row['billerCode'] as String?,
            billerLogoUUID: row['billerLogoUUID'] as String?,
            billerProductName: row['billerProductName'] as String?,
            billerProductCode: row['billerProductCode'] as String?,
            transactionId: row['transactionId'] as String?,
            token: row['token'] as String?),
        arguments: [startDate, endDate, myOffset, limit],
        queryableName: 'bill_transactions',
        isView: false);
  }

  @override
  Future<BillTransaction?> getBillTransactionById(int id) async {
    return _queryAdapter.query('SELECT * FROM bill_transactions WHERE id = ?1',
        mapper: (Map<String, Object?> row) => BillTransaction(
            id: row['id'] as int?,
            minorAmount: row['minorAmount'] as int?,
            sourceAccountProviderName:
                row['sourceAccountProviderName'] as String?,
            sourceAccountNumber: row['sourceAccountNumber'] as String?,
            sourceAccountCurrencyCode:
                row['sourceAccountCurrencyCode'] as String?,
            transactionStatus: row['transactionStatus'] as String?,
            transactionTime: row['transactionTime'] as int?,
            customerId: row['customerId'] as String?,
            customerIdName: row['customerIdName'] as String?,
            billerCategoryName: row['billerCategoryName'] as String?,
            billerCategoryCode: row['billerCategoryCode'] as String?,
            billerName: row['billerName'] as String?,
            billerCode: row['billerCode'] as String?,
            billerLogoUUID: row['billerLogoUUID'] as String?,
            billerProductName: row['billerProductName'] as String?,
            billerProductCode: row['billerProductCode'] as String?,
            transactionId: row['transactionId'] as String?,
            token: row['token'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM bill_transactions');
  }

  @override
  Future<void> insertItem(BillTransaction item) async {
    await _billTransactionInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<BillTransaction> item) async {
    await _billTransactionInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<BillTransaction> item) async {
    await _billTransactionDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(BillTransaction item) async {
    await _billTransactionDeletionAdapter.delete(item);
  }
}

class _$BillBeneficiaryDao extends BillBeneficiaryDao {
  _$BillBeneficiaryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _billBeneficiaryInsertionAdapter = InsertionAdapter(
            database,
            'bill_beneficiaries',
            (BillBeneficiary item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'billerCode': item.billerCode,
                  'billerCategoryLogo': item.billerCategoryLogo,
                  'biller': _billerConverter.encode(item.biller),
                  'billerProducts':
                      _listBillerProductConverter.encode(item.billerProducts),
                  'billerName': item.billerName,
                  'customerIdentity': item.customerIdentity,
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener),
        _billBeneficiaryDeletionAdapter = DeletionAdapter(
            database,
            'bill_beneficiaries',
            ['id'],
            (BillBeneficiary item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'billerCode': item.billerCode,
                  'billerCategoryLogo': item.billerCategoryLogo,
                  'biller': _billerConverter.encode(item.biller),
                  'billerProducts':
                      _listBillerProductConverter.encode(item.billerProducts),
                  'billerName': item.billerName,
                  'customerIdentity': item.customerIdentity,
                  'frequency': item.frequency,
                  'lastUpdated': item.lastUpdated
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BillBeneficiary> _billBeneficiaryInsertionAdapter;

  final DeletionAdapter<BillBeneficiary> _billBeneficiaryDeletionAdapter;

  @override
  Stream<List<BillBeneficiary>> getFrequentBeneficiaries(int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM bill_beneficiaries ORDER BY frequency DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => BillBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            billerCategoryLogo: row['billerCategoryLogo'] as String?,
            billerCode: row['billerCode'] as String?,
            biller: _billerConverter.decode(row['biller'] as String?),
            billerProducts: _listBillerProductConverter
                .decode(row['billerProducts'] as String?),
            billerName: row['billerName'] as String?,
            customerIdentity: row['customerIdentity'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [limit],
        queryableName: 'bill_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<BillBeneficiary>> getPagedBillBeneficiary(
      int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM bill_beneficiaries ORDER BY frequency DESC LIMIT ?2 OFFSET ?1',
        mapper: (Map<String, Object?> row) => BillBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            billerCategoryLogo: row['billerCategoryLogo'] as String?,
            billerCode: row['billerCode'] as String?,
            biller: _billerConverter.decode(row['biller'] as String?),
            billerProducts: _listBillerProductConverter
                .decode(row['billerProducts'] as String?),
            billerName: row['billerName'] as String?,
            customerIdentity: row['customerIdentity'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [myOffset, limit],
        queryableName: 'bill_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<BillBeneficiary>> getFrequentBeneficiariesByBiller(
      int limit, String billerCode) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM bill_beneficiaries WHERE billerCode=?2 ORDER BY frequency DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => BillBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            billerCategoryLogo: row['billerCategoryLogo'] as String?,
            billerCode: row['billerCode'] as String?,
            biller: _billerConverter.decode(row['biller'] as String?),
            billerProducts: _listBillerProductConverter
                .decode(row['billerProducts'] as String?),
            billerName: row['billerName'] as String?,
            customerIdentity: row['customerIdentity'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [limit, billerCode],
        queryableName: 'bill_beneficiaries',
        isView: false);
  }

  @override
  Stream<List<BillBeneficiary>> searchPagedBillBeneficiary(
      String search, int myOffset, int limit) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM bill_beneficiaries WHERE name LIKE ?1 OR customerIdentity LIKE ?1 ORDER BY name ASC LIMIT ?3 OFFSET ?2',
        mapper: (Map<String, Object?> row) => BillBeneficiary(
            id: row['id'] as int,
            name: row['name'] as String?,
            billerCategoryLogo: row['billerCategoryLogo'] as String?,
            billerCode: row['billerCode'] as String?,
            biller: _billerConverter.decode(row['biller'] as String?),
            billerProducts: _listBillerProductConverter
                .decode(row['billerProducts'] as String?),
            billerName: row['billerName'] as String?,
            customerIdentity: row['customerIdentity'] as String?,
            frequency: row['frequency'] as int?,
            lastUpdated: row['lastUpdated'] as int?),
        arguments: [search, myOffset, limit],
        queryableName: 'bill_beneficiaries',
        isView: false);
  }

  @override
  Future<void> deleteAll(List<String> customerIds) async {
    const offset = 1;
    final _sqliteVariablesForCustomerIds =
        Iterable<String>.generate(customerIds.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM bill_beneficiaries WHERE customerIdentity NOT IN(' +
            _sqliteVariablesForCustomerIds +
            ')',
        arguments: [...customerIds]);
  }

  @override
  Future<void> insertItem(BillBeneficiary item) async {
    await _billBeneficiaryInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<BillBeneficiary> item) async {
    await _billBeneficiaryInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<BillBeneficiary> item) async {
    await _billBeneficiaryDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(BillBeneficiary item) async {
    await _billBeneficiaryDeletionAdapter.delete(item);
  }
}

class _$BillerDao extends BillerDao {
  _$BillerDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _billerInsertionAdapter = InsertionAdapter(
            database,
            'billers',
            (Biller item) => <String, Object?>{
                  'billerCategoryId': item.billerCategoryId,
                  'billerCategoryCode': item.billerCategoryCode,
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'identifierName': item.identifierName,
                  'currencySymbol': item.currencySymbol,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'collectionAccountNumber': item.collectionAccountNumber,
                  'collectionAccountName': item.collectionAccountName,
                  'collectionAccountProviderCode':
                      item.collectionAccountProviderCode,
                  'collectionAccountProviderName':
                      item.collectionAccountProviderName,
                  'svgImage': item.svgImage,
                  'logoImageUUID': item.logoImageUUID
                },
            changeListener),
        _billerDeletionAdapter = DeletionAdapter(
            database,
            'billers',
            ['id'],
            (Biller item) => <String, Object?>{
                  'billerCategoryId': item.billerCategoryId,
                  'billerCategoryCode': item.billerCategoryCode,
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'identifierName': item.identifierName,
                  'currencySymbol': item.currencySymbol,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'collectionAccountNumber': item.collectionAccountNumber,
                  'collectionAccountName': item.collectionAccountName,
                  'collectionAccountProviderCode':
                      item.collectionAccountProviderCode,
                  'collectionAccountProviderName':
                      item.collectionAccountProviderName,
                  'svgImage': item.svgImage,
                  'logoImageUUID': item.logoImageUUID
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Biller> _billerInsertionAdapter;

  final DeletionAdapter<Biller> _billerDeletionAdapter;

  @override
  Stream<List<Biller>> getBillersForCategory(String categoryId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM billers WHERE billerCategoryCode =?1',
        mapper: (Map<String, Object?> row) => Biller(
            billerCategoryId: row['billerCategoryId'] as String?,
            billerCategoryCode: row['billerCategoryCode'] as String?,
            id: row['id'] as int,
            name: row['name'] as String?,
            code: row['code'] as String?,
            identifierName: row['identifierName'] as String?,
            currencySymbol: row['currencySymbol'] as String?,
            active: row['active'] == null ? null : (row['active'] as int) != 0,
            collectionAccountNumber: row['collectionAccountNumber'] as String?,
            collectionAccountName: row['collectionAccountName'] as String?,
            collectionAccountProviderCode:
                row['collectionAccountProviderCode'] as String?,
            collectionAccountProviderName:
                row['collectionAccountProviderName'] as String?,
            svgImage: row['svgImage'] as String?,
            logoImageUUID: row['logoImageUUID'] as String?),
        arguments: [categoryId],
        queryableName: 'billers',
        isView: false);
  }

  @override
  Stream<List<Biller>> searchBillerByCategoryIdAndName(
      String categoryId, String billerName) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM billers WHERE billerCategoryCode=?1 AND name LIKE ?2',
        mapper: (Map<String, Object?> row) => Biller(
            billerCategoryId: row['billerCategoryId'] as String?,
            billerCategoryCode: row['billerCategoryCode'] as String?,
            id: row['id'] as int,
            name: row['name'] as String?,
            code: row['code'] as String?,
            identifierName: row['identifierName'] as String?,
            currencySymbol: row['currencySymbol'] as String?,
            active: row['active'] == null ? null : (row['active'] as int) != 0,
            collectionAccountNumber: row['collectionAccountNumber'] as String?,
            collectionAccountName: row['collectionAccountName'] as String?,
            collectionAccountProviderCode:
                row['collectionAccountProviderCode'] as String?,
            collectionAccountProviderName:
                row['collectionAccountProviderName'] as String?,
            svgImage: row['svgImage'] as String?,
            logoImageUUID: row['logoImageUUID'] as String?),
        arguments: [categoryId, billerName],
        queryableName: 'billers',
        isView: false);
  }

  @override
  Future<void> deleteByCategory(String categoryId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM billers WHERE billerCategoryCode=?1',
        arguments: [categoryId]);
  }

  @override
  Future<void> insertItem(Biller item) async {
    await _billerInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<Biller> item) async {
    await _billerInsertionAdapter.insertList(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<Biller> item) async {
    await _billerDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(Biller item) async {
    await _billerDeletionAdapter.delete(item);
  }
}

class _$BillerCategoryDao extends BillerCategoryDao {
  _$BillerCategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _billerCategoryInsertionAdapter = InsertionAdapter(
            database,
            'biller_categories',
            (BillerCategory item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'categoryCode': item.categoryCode,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'svgImage': item.svgImage
                },
            changeListener),
        _billerCategoryDeletionAdapter = DeletionAdapter(
            database,
            'biller_categories',
            ['id'],
            (BillerCategory item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description,
                  'categoryCode': item.categoryCode,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'svgImage': item.svgImage
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BillerCategory> _billerCategoryInsertionAdapter;

  final DeletionAdapter<BillerCategory> _billerCategoryDeletionAdapter;

  @override
  Stream<List<BillerCategory>> getAllBillerCategories() {
    return _queryAdapter.queryListStream('SELECT * FROM biller_categories',
        mapper: (Map<String, Object?> row) => BillerCategory(
            id: row['id'] as int,
            name: row['name'] as String?,
            description: row['description'] as String?,
            categoryCode: row['categoryCode'] as String?,
            active: row['active'] == null ? null : (row['active'] as int) != 0,
            svgImage: row['svgImage'] as String?),
        queryableName: 'biller_categories',
        isView: false);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM biller_categories');
  }

  @override
  Future<void> insertItem(BillerCategory item) async {
    await _billerCategoryInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<BillerCategory> item) async {
    await _billerCategoryInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<BillerCategory> item) async {
    await _billerCategoryDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(BillerCategory item) async {
    await _billerCategoryDeletionAdapter.delete(item);
  }
}

class _$BillerProductDao extends BillerProductDao {
  _$BillerProductDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _billerProductInsertionAdapter = InsertionAdapter(
            database,
            'biller_products',
            (BillerProduct item) => <String, Object?>{
                  'billerCode': item.billerCode,
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'amount': item.amount,
                  'fee': item.fee,
                  'paymentCode': item.paymentCode,
                  'currencySymbol': item.currencySymbol,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'priceFixed': item.priceFixed == null
                      ? null
                      : (item.priceFixed! ? 1 : 0),
                  'minimumAmount': item.minimumAmount,
                  'maximumAmount': item.maximumAmount,
                  'identifierName': item.identifierName,
                  'additionalFieldsMap': _additionalFieldsConverter
                      .encode(item.additionalFieldsMap),
                  'billerName': item.billerName
                },
            changeListener),
        _billerProductDeletionAdapter = DeletionAdapter(
            database,
            'biller_products',
            ['id'],
            (BillerProduct item) => <String, Object?>{
                  'billerCode': item.billerCode,
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'amount': item.amount,
                  'fee': item.fee,
                  'paymentCode': item.paymentCode,
                  'currencySymbol': item.currencySymbol,
                  'active': item.active == null ? null : (item.active! ? 1 : 0),
                  'priceFixed': item.priceFixed == null
                      ? null
                      : (item.priceFixed! ? 1 : 0),
                  'minimumAmount': item.minimumAmount,
                  'maximumAmount': item.maximumAmount,
                  'identifierName': item.identifierName,
                  'additionalFieldsMap': _additionalFieldsConverter
                      .encode(item.additionalFieldsMap),
                  'billerName': item.billerName
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BillerProduct> _billerProductInsertionAdapter;

  final DeletionAdapter<BillerProduct> _billerProductDeletionAdapter;

  @override
  Stream<List<BillerProduct>> getProductsByBiller(String billerCode) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM biller_products WHERE billerCode =?1',
        mapper: (Map<String, Object?> row) => BillerProduct(
            billerCode: row['billerCode'] as String?,
            id: row['id'] as int,
            name: row['name'] as String?,
            code: row['code'] as String?,
            amount: row['amount'] as double?,
            fee: row['fee'] as double?,
            paymentCode: row['paymentCode'] as String?,
            currencySymbol: row['currencySymbol'] as String?,
            active: row['active'] == null ? null : (row['active'] as int) != 0,
            priceFixed: row['priceFixed'] == null
                ? null
                : (row['priceFixed'] as int) != 0,
            minimumAmount: row['minimumAmount'] as double?,
            maximumAmount: row['maximumAmount'] as double?,
            identifierName: row['identifierName'] as String?,
            additionalFieldsMap: _additionalFieldsConverter
                .decode(row['additionalFieldsMap'] as String?),
            billerName: row['billerName'] as String?),
        arguments: [billerCode],
        queryableName: 'biller_products',
        isView: false);
  }

  @override
  Future<void> deleteByBiller(
      String billerCode, List<String> paymentCodes, List<int> ids) async {
    int offset = 2;
    final _sqliteVariablesForPaymentCodes =
        Iterable<String>.generate(paymentCodes.length, (i) => '?${i + offset}')
            .join(',');
    offset += paymentCodes.length;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM biller_products WHERE billerCode =?1 AND (paymentCode NOT IN (' +
            _sqliteVariablesForPaymentCodes +
            ') OR id NOT IN(' +
            _sqliteVariablesForIds +
            '))',
        arguments: [billerCode, ...paymentCodes, ...ids]);
  }

  @override
  Future<void> insertItem(BillerProduct item) async {
    await _billerProductInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<BillerProduct> item) async {
    await _billerProductInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<BillerProduct> item) async {
    await _billerProductDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(BillerProduct item) async {
    await _billerProductDeletionAdapter.delete(item);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _accountTransactionInsertionAdapter = InsertionAdapter(
            database,
            'account_transactions',
            (AccountTransaction item) => <String, Object?>{
                  'id': item.id,
                  'accountNumber': item.accountNumber,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'transactionRef': item.transactionRef,
                  'amount': item.amount,
                  'type': _transactionTypeConverter.encode(item.type),
                  'transactionChannel': item.transactionChannel,
                  'tags': item.tags,
                  'narration': item.narration,
                  'transactionDate': item.transactionDate,
                  'runningBalance': item.runningBalance,
                  'balanceBefore': item.balanceBefore,
                  'balanceAfter': item.balanceAfter,
                  'transactionCategory': _transactionCategoryConverter
                      .encode(item.transactionCategory),
                  'transactionCode': item.transactionCode,
                  'beneficiaryIdentifier': item.beneficiaryIdentifier,
                  'beneficiaryName': item.beneficiaryName,
                  'beneficiaryBankName': item.beneficiaryBankName,
                  'beneficiaryBankCode': item.beneficiaryBankCode,
                  'senderIdentifier': item.senderIdentifier,
                  'senderName': item.senderName,
                  'senderBankName': item.senderBankName,
                  'senderBankCode': item.senderBankCode,
                  'providerIdentifier': item.providerIdentifier,
                  'providerName': item.providerName,
                  'transactionIdentifier': item.transactionIdentifier,
                  'merchantLocation': item.merchantLocation,
                  'cardScheme': item.cardScheme,
                  'maskedPan': item.maskedPan,
                  'terminalID': item.terminalID,
                  'disputable': item.disputable == null
                      ? null
                      : (item.disputable! ? 1 : 0),
                  'location': _locationConverter.encode(item.location),
                  'metaData':
                      _transactionMetaDataConverter.encode(item.metaData),
                  'customerAccountId': item.customerAccountId
                },
            changeListener),
        _accountTransactionDeletionAdapter = DeletionAdapter(
            database,
            'account_transactions',
            ['transactionRef'],
            (AccountTransaction item) => <String, Object?>{
                  'id': item.id,
                  'accountNumber': item.accountNumber,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'transactionRef': item.transactionRef,
                  'amount': item.amount,
                  'type': _transactionTypeConverter.encode(item.type),
                  'transactionChannel': item.transactionChannel,
                  'tags': item.tags,
                  'narration': item.narration,
                  'transactionDate': item.transactionDate,
                  'runningBalance': item.runningBalance,
                  'balanceBefore': item.balanceBefore,
                  'balanceAfter': item.balanceAfter,
                  'transactionCategory': _transactionCategoryConverter
                      .encode(item.transactionCategory),
                  'transactionCode': item.transactionCode,
                  'beneficiaryIdentifier': item.beneficiaryIdentifier,
                  'beneficiaryName': item.beneficiaryName,
                  'beneficiaryBankName': item.beneficiaryBankName,
                  'beneficiaryBankCode': item.beneficiaryBankCode,
                  'senderIdentifier': item.senderIdentifier,
                  'senderName': item.senderName,
                  'senderBankName': item.senderBankName,
                  'senderBankCode': item.senderBankCode,
                  'providerIdentifier': item.providerIdentifier,
                  'providerName': item.providerName,
                  'transactionIdentifier': item.transactionIdentifier,
                  'merchantLocation': item.merchantLocation,
                  'cardScheme': item.cardScheme,
                  'maskedPan': item.maskedPan,
                  'terminalID': item.terminalID,
                  'disputable': item.disputable == null
                      ? null
                      : (item.disputable! ? 1 : 0),
                  'location': _locationConverter.encode(item.location),
                  'metaData':
                      _transactionMetaDataConverter.encode(item.metaData),
                  'customerAccountId': item.customerAccountId
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccountTransaction>
      _accountTransactionInsertionAdapter;

  final DeletionAdapter<AccountTransaction> _accountTransactionDeletionAdapter;

  @override
  Stream<List<AccountTransaction>> getTransactions(
      int customerAccountId, int limit, int myOffset) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 ORDER BY transactionDate DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [customerAccountId, limit, myOffset],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByAllCriteria(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> channels,
      List<String> transactionTypes,
      int limit,
      int myOffset) {
    int offset = 6;
    final _sqliteVariablesForChannels =
        Iterable<String>.generate(channels.length, (i) => '?${i + offset}')
            .join(',');
    offset += channels.length;
    final _sqliteVariablesForTransactionTypes = Iterable<String>.generate(
        transactionTypes.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionDate BETWEEN ?2 AND ?3) AND (transactionChannel IN (' +
            _sqliteVariablesForChannels +
            ')) AND type IN (' +
            _sqliteVariablesForTransactionTypes +
            ') ORDER BY transactionDate DESC LIMIT ?4 OFFSET ?5',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [
          customerAccountId,
          startDate,
          endDate,
          limit,
          myOffset,
          ...channels,
          ...transactionTypes
        ],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByDate(
      int customerAccountId,
      int startDate,
      int endDate,
      int limit,
      int myOffset) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionDate BETWEEN ?2 AND ?3) ORDER BY transactionDate DESC LIMIT ?4 OFFSET ?5',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [customerAccountId, startDate, endDate, limit, myOffset],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByChannels(
      int customerAccountId, List<String> channels, int limit, int myOffset) {
    const offset = 4;
    final _sqliteVariablesForChannels =
        Iterable<String>.generate(channels.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionChannel IN (' +
            _sqliteVariablesForChannels +
            ')) ORDER BY transactionDate DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [customerAccountId, limit, myOffset, ...channels],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByTypes(
      int customerAccountId,
      List<String> transactionTypes,
      int limit,
      int myOffset) {
    const offset = 4;
    final _sqliteVariablesForTransactionTypes = Iterable<String>.generate(
        transactionTypes.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND type IN (' +
            _sqliteVariablesForTransactionTypes +
            ') ORDER BY transactionDate DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [customerAccountId, limit, myOffset, ...transactionTypes],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByDateAndChannels(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> channels,
      int limit,
      int myOffset) {
    const offset = 6;
    final _sqliteVariablesForChannels =
        Iterable<String>.generate(channels.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionDate BETWEEN ?2 AND ?3) AND (transactionChannel IN (' +
            _sqliteVariablesForChannels +
            ')) ORDER BY transactionDate DESC LIMIT ?4 OFFSET ?5',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [
          customerAccountId,
          startDate,
          endDate,
          limit,
          myOffset,
          ...channels
        ],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByDateAndTypes(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> transactionTypes,
      int limit,
      int myOffset) {
    const offset = 6;
    final _sqliteVariablesForTransactionTypes = Iterable<String>.generate(
        transactionTypes.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionDate BETWEEN ?2 AND ?3) AND type IN (' +
            _sqliteVariablesForTransactionTypes +
            ') ORDER BY transactionDate DESC LIMIT ?4 OFFSET ?5',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [
          customerAccountId,
          startDate,
          endDate,
          limit,
          myOffset,
          ...transactionTypes
        ],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Stream<List<AccountTransaction>> filterTransactionByChannelsAndTypes(
      int customerAccountId,
      List<String> channels,
      List<String> transactionTypes,
      int limit,
      int myOffset) {
    int offset = 4;
    final _sqliteVariablesForChannels =
        Iterable<String>.generate(channels.length, (i) => '?${i + offset}')
            .join(',');
    offset += channels.length;
    final _sqliteVariablesForTransactionTypes = Iterable<String>.generate(
        transactionTypes.length, (i) => '?${i + offset}').join(',');
    return _queryAdapter.queryListStream(
        'SELECT * FROM account_transactions WHERE customerAccountId = ?1 AND (transactionChannel IN (' +
            _sqliteVariablesForChannels +
            ')) AND type IN (' +
            _sqliteVariablesForTransactionTypes +
            ') ORDER BY transactionDate DESC LIMIT ?2 OFFSET ?3',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [
          customerAccountId,
          limit,
          myOffset,
          ...channels,
          ...transactionTypes
        ],
        queryableName: 'account_transactions',
        isView: false);
  }

  @override
  Future<AccountTransaction?> getTransactionByRef(String tranRef) async {
    return _queryAdapter.query(
        'SELECT * FROM account_transactions WHERE transactionRef =?1',
        mapper: (Map<String, Object?> row) => AccountTransaction(
            id: row['id'] as int?,
            transactionDate: row['transactionDate'] as int,
            transactionRef: row['transactionRef'] as String,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            amount: row['amount'] as double?,
            type: _transactionTypeConverter.decode(row['type'] as String?),
            transactionChannel: row['transactionChannel'] as String?,
            tags: row['tags'] as String?,
            narration: row['narration'] as String?,
            runningBalance: row['runningBalance'] as String?,
            balanceBefore: row['balanceBefore'] as String?,
            balanceAfter: row['balanceAfter'] as String?,
            metaData: _transactionMetaDataConverter
                .decode(row['metaData'] as String?),
            customerAccountId: row['customerAccountId'] as int?,
            transactionCategory: _transactionCategoryConverter
                .decode(row['transactionCategory'] as String?),
            transactionCode: row['transactionCode'] as String?,
            beneficiaryIdentifier: row['beneficiaryIdentifier'] as String?,
            beneficiaryName: row['beneficiaryName'] as String?,
            beneficiaryBankName: row['beneficiaryBankName'] as String?,
            beneficiaryBankCode: row['beneficiaryBankCode'] as String?,
            senderIdentifier: row['senderIdentifier'] as String?,
            senderName: row['senderName'] as String?,
            senderBankName: row['senderBankName'] as String?,
            senderBankCode: row['senderBankCode'] as String?,
            providerIdentifier: row['providerIdentifier'] as String?,
            providerName: row['providerName'] as String?,
            transactionIdentifier: row['transactionIdentifier'] as String?,
            merchantLocation: row['merchantLocation'] as String?,
            cardScheme: row['cardScheme'] as String?,
            maskedPan: row['maskedPan'] as String?,
            terminalID: row['terminalID'] as String?,
            disputable: row['disputable'] == null
                ? null
                : (row['disputable'] as int) != 0,
            location: _locationConverter.decode(row['location'] as String?)),
        arguments: [tranRef]);
  }

  @override
  Future<void> deleteOldAccountTransactions(
      List<String> transactionRefs) async {
    const offset = 1;
    final _sqliteVariablesForTransactionRefs = Iterable<String>.generate(
        transactionRefs.length, (i) => '?${i + offset}').join(',');
    await _queryAdapter.queryNoReturn(
        'DELETE FROM account_transactions WHERE transactionRef NOT IN(' +
            _sqliteVariablesForTransactionRefs +
            ')',
        arguments: [...transactionRefs]);
  }

  @override
  Future<void> insertItem(AccountTransaction item) async {
    await _accountTransactionInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<AccountTransaction> item) async {
    await _accountTransactionInsertionAdapter.insertList(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<AccountTransaction> item) async {
    await _accountTransactionDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(AccountTransaction item) async {
    await _accountTransactionDeletionAdapter.delete(item);
  }

  @override
  Future<void> deleteAndInsert(List<AccountTransaction> items) async {
    if (database is sqflite.Transaction) {
      await super.deleteAndInsert(items);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$AppDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.transactionDao.deleteAndInsert(items);
      });
    }
  }
}

class _$SchemeDao extends SchemeDao {
  _$SchemeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _tierInsertionAdapter = InsertionAdapter(
            database,
            'tiers',
            (Tier item) => <String, Object?>{
                  'id': item.id,
                  'status': item.status,
                  'createdOn': item.createdOn,
                  'lastModifiedOn': item.lastModifiedOn,
                  'code': item.code,
                  'name': item.name,
                  'classification': item.classification,
                  'accountNumberPrefix': item.accountNumberPrefix,
                  'accountNumberLength': item.accountNumberLength,
                  'allowNegativeBalance': item.allowNegativeBalance == null
                      ? null
                      : (item.allowNegativeBalance! ? 1 : 0),
                  'allowLien':
                      item.allowLien == null ? null : (item.allowLien! ? 1 : 0),
                  'enableInstantBalanceUpdate':
                      item.enableInstantBalanceUpdate == null
                          ? null
                          : (item.enableInstantBalanceUpdate! ? 1 : 0),
                  'maximumCumulativeBalance': item.maximumCumulativeBalance,
                  'maximumSingleDebit': item.maximumSingleDebit,
                  'maximumSingleCredit': item.maximumSingleCredit,
                  'maximumDailyDebit': item.maximumDailyDebit,
                  'maximumDailyCredit': item.maximumDailyCredit,
                  'schemeRequirement': _schemeRequirementConverter
                      .encode(item.schemeRequirement),
                  'alternateSchemeRequirement':
                      _alternateSchemeRequirementConverter
                          .encode(item.alternateSchemeRequirement),
                  'supportsAccountGeneration':
                      item.supportsAccountGeneration == null
                          ? null
                          : (item.supportsAccountGeneration! ? 1 : 0)
                },
            changeListener),
        _tierDeletionAdapter = DeletionAdapter(
            database,
            'tiers',
            ['id'],
            (Tier item) => <String, Object?>{
                  'id': item.id,
                  'status': item.status,
                  'createdOn': item.createdOn,
                  'lastModifiedOn': item.lastModifiedOn,
                  'code': item.code,
                  'name': item.name,
                  'classification': item.classification,
                  'accountNumberPrefix': item.accountNumberPrefix,
                  'accountNumberLength': item.accountNumberLength,
                  'allowNegativeBalance': item.allowNegativeBalance == null
                      ? null
                      : (item.allowNegativeBalance! ? 1 : 0),
                  'allowLien':
                      item.allowLien == null ? null : (item.allowLien! ? 1 : 0),
                  'enableInstantBalanceUpdate':
                      item.enableInstantBalanceUpdate == null
                          ? null
                          : (item.enableInstantBalanceUpdate! ? 1 : 0),
                  'maximumCumulativeBalance': item.maximumCumulativeBalance,
                  'maximumSingleDebit': item.maximumSingleDebit,
                  'maximumSingleCredit': item.maximumSingleCredit,
                  'maximumDailyDebit': item.maximumDailyDebit,
                  'maximumDailyCredit': item.maximumDailyCredit,
                  'schemeRequirement': _schemeRequirementConverter
                      .encode(item.schemeRequirement),
                  'alternateSchemeRequirement':
                      _alternateSchemeRequirementConverter
                          .encode(item.alternateSchemeRequirement),
                  'supportsAccountGeneration':
                      item.supportsAccountGeneration == null
                          ? null
                          : (item.supportsAccountGeneration! ? 1 : 0)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tier> _tierInsertionAdapter;

  final DeletionAdapter<Tier> _tierDeletionAdapter;

  @override
  Stream<List<Tier>> getSchemes() {
    return _queryAdapter.queryListStream('SELECT * FROM tiers ORDER BY id',
        mapper: (Map<String, Object?> row) => Tier(
            id: row['id'] as int,
            status: row['status'] as String?,
            createdOn: row['createdOn'] as String?,
            lastModifiedOn: row['lastModifiedOn'] as String?,
            code: row['code'] as String?,
            name: row['name'] as String?,
            classification: row['classification'] as String?,
            accountNumberPrefix: row['accountNumberPrefix'] as String?,
            accountNumberLength: row['accountNumberLength'] as int?,
            allowNegativeBalance: row['allowNegativeBalance'] == null
                ? null
                : (row['allowNegativeBalance'] as int) != 0,
            allowLien: row['allowLien'] == null
                ? null
                : (row['allowLien'] as int) != 0,
            enableInstantBalanceUpdate:
                row['enableInstantBalanceUpdate'] == null
                    ? null
                    : (row['enableInstantBalanceUpdate'] as int) != 0,
            maximumCumulativeBalance:
                row['maximumCumulativeBalance'] as double?,
            maximumSingleDebit: row['maximumSingleDebit'] as double?,
            maximumSingleCredit: row['maximumSingleCredit'] as double?,
            maximumDailyDebit: row['maximumDailyDebit'] as double?,
            maximumDailyCredit: row['maximumDailyCredit'] as double?,
            schemeRequirement: _schemeRequirementConverter
                .decode(row['schemeRequirement'] as String?),
            alternateSchemeRequirement: _alternateSchemeRequirementConverter
                .decode(row['alternateSchemeRequirement'] as String?),
            supportsAccountGeneration: row['supportsAccountGeneration'] == null
                ? null
                : (row['supportsAccountGeneration'] as int) != 0),
        queryableName: 'tiers',
        isView: false);
  }

  @override
  Future<void> deleteAllTiers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM tiers');
  }

  @override
  Future<void> insertItem(Tier item) async {
    await _tierInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertItems(List<Tier> item) async {
    await _tierInsertionAdapter.insertList(item, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteItems(List<Tier> item) async {
    await _tierDeletionAdapter.deleteList(item);
  }

  @override
  Future<void> deleteItem(Tier item) async {
    await _tierDeletionAdapter.delete(item);
  }
}

// ignore_for_file: unused_element
final _listStateConverter = ListStateConverter();
final _listStringConverter = ListStringConverter();
final _listBoundedChargesConverter = ListBoundedChargesConverter();
final _transferBatchConverter = TransferBatchConverter();
final _transferHistoryItemConverter = TransferHistoryItemConverter();
final _transactionBatchConverter = TransactionBatchConverter();
final _airtimeHistoryItemConverter = AirtimeHistoryItemConverter();
final _airtimeServiceProviderConverter = AirtimeServiceProviderConverter();
final _billerConverter = BillerConverter();
final _listBillerProductConverter = ListBillerProductConverter();
final _additionalFieldsConverter = AdditionalFieldsConverter();
final _transactionTypeConverter = TransactionTypeConverter();
final _transactionCategoryConverter = TransactionCategoryConverter();
final _locationConverter = LocationConverter();
final _transactionMetaDataConverter = TransactionMetaDataConverter();
final _schemeRequirementConverter = SchemeRequirementConverter();
final _alternateSchemeRequirementConverter =
    AlternateSchemeRequirementConverter();
