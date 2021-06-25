
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/download_transaction_receipt_request_body.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/export_statement_request_body.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_dao.dart';
import 'package:moniepoint_flutter/app/accounts/model/transaction_service.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

class TransactionServiceDelegate with NetworkResource {
  late final TransactionService _service;
  late final TransactionDao _transactionDao;

  TransactionServiceDelegate(TransactionService service, TransactionDao transactionDao) {
    this._service = service;
    this._transactionDao = transactionDao;
  }

  PagingSource<int, AccountTransaction> getPageAccountTransactions(int customerAccountId, FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;

          final channels = (filterResult.channels.isEmpty) ? [...TransactionChannel.values] : filterResult.channels;
          final types = (filterResult.types.isEmpty) ? [...TransactionType.values] : filterResult.types;

          return _transactionDao.getTransactionsByFilter(
              filterResult.startDate,
              filterResult.endDate,
              channels.map((e) => describeEnum(e)).toList(),
              types.map((e) => describeEnum(e)).toList(),
              params.loadSize,
              offset * params.loadSize,
          ).map((event) {
            return Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null);
          });
        },
        remoteMediator: _TransactionRemoteMediator(_service, _transactionDao)..filterResults = filterResult..customerAccountId = customerAccountId
    );
  }

  Future<AccountTransaction?> getSingleAccountTransaction(String transactionRef){
    return _transactionDao.getTransactionByRef(transactionRef);
  }

  Stream<Uint8List> exportStatement(ExportStatementRequestBody requestBody) async* {
    final a = (await _service.exportStatement(requestBody)) as ResponseBody;
    yield* a.stream;
  }

  Stream<Uint8List> downloadTransactionReceipt(DownloadTransactionReceiptRequestBody requestBody) async* {
    final a = (await _service.downloadTransactionReceipt(requestBody)) as ResponseBody;
    yield* a.stream;
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
    await _transactionDao.deleteOldAccountTransactions(items.map((e) => e.transactionRef).toList());
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