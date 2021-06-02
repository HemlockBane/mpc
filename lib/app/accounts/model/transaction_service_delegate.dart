
import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_status.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

class TransactionServiceDelegate with NetworkResource {
  late final TransactionService _service;
  late final TransactionDao _transactionDao;
  late final _remoteMediator;

  TransactionServiceDelegate(TransactionService service, TransactionDao transactionDao) {
    this._service = service;
    this._transactionDao = transactionDao;
    this._remoteMediator =  _TransactionRemoteMediator(_service, _transactionDao);
  }

  PagingSource<int, AccountTransaction> getPageAccountTransactions(int customerAccountId, FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _transactionDao.getTransactionsByFilter(
              filterResult.startDate,
              filterResult.endDate,
              filterResult.channels.map((e) => describeEnum(e)).toList(),
              filterResult.types.map((e) => describeEnum(e)).toList(),
              0,
              params.loadSize
          ).map((event) {
            print("DATA RECEIVED $event");
            return Page(event, params.key, event.length == params.loadSize ? offset + 1 : null);
          });
        },
        remoteMediator: _remoteMediator..filterResults = filterResult..customerAccountId = customerAccountId
    );
  }

}

class _TransactionRemoteMediator extends AbstractDataCollectionMediator<int, AccountTransaction> {

  TransactionService _transactionService;
  TransactionDao _transactionDao;
  FilterResults? filterResults;
  int? customerAccountId;

  _TransactionRemoteMediator(this._transactionService, this._transactionDao);

  @override
  Future<void> clearDB(List<AccountTransaction> items) async {
    //await _transactionDao.deleteOldAccountTransactions(items.map((e) => e.transactionRef).toList());
  }

  @override
  Future<void> saveToDB(List<AccountTransaction> value) async {
    await _transactionDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<AccountTransaction>>> serviceCall(int page) {
    return _transactionService.getTransactionsFilter(
        customerAccountId ?? 0,
        "ALL",
        null,
        filterResults?.startDate ?? 0,
        filterResults?.endDate ?? 0,
        page,
        20
    );
  }

}