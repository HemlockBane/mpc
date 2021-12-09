
import 'dart:collection';

import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/data/savings_product.dart';
import 'package:moniepoint_flutter/app/savings/model/data/total_savings_balance.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/dao/flex_transaction_dao.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_account_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_free_withdrawal_count_request.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/dao/flex_savings_dao.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_request.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_response.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_withdrawal_count.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

import 'data/enable_flex_request_body.dart';

///@author Paul Okeke
///
class SavingsProductServiceDelegate with NetworkResource {

  late final SavingsProductService _service;
  late final FlexSavingsDao _flexSavingsDao;
  late final FlexTransactionDao _flexTransactionDao;

  static const FLEX_WITHDRAWAL_COUNT_KEY = "FLEX_WITHDRAWAL_COUNT";

  SavingsProductServiceDelegate(
      SavingsProductService service,
      FlexSavingsDao flexSavingsDao,
      FlexTransactionDao flexTransactionDao
      ) {
    this._service = service;
    this._flexSavingsDao = flexSavingsDao;
    this._flexTransactionDao = flexTransactionDao;
  }

  final LinkedHashMap<int, AccountBalance> _flexIdToAccountBalance = LinkedHashMap();
  TotalSavingsBalance? _totalSavingsBalance;

  Stream<Resource<SavingsProduct>> getFlexProduct() {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getFlexProduct(),
        processRemoteResponse: (resp) {
          resp.data?.result?.totalSavingsBalance = _totalSavingsBalance;
        }
    );
  }

  Stream<Resource<List<FlexSaving>>> getRunningFlexSavings(int customerId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _flexSavingsDao.getFlexSavings().map((event) {
          event.forEach((element) {
            element.accountBalance = _flexIdToAccountBalance[element.id];
          });
          return event;
        }),
        fetchFromRemote: () => this._service.getRunningFlexSavings(customerId),
        saveRemoteData: (data) async {
          await _flexSavingsDao.deleteOldRecords(data.map((e) => e.id).toList());
          await _flexSavingsDao.insertItems(data);
        }
    );
  }

  Future<FlexSaving?> getSingleFlexSaving(int flexSavingId) async {
    final flexSaving = await _flexSavingsDao.getFlexSavingById(flexSavingId);
    flexSaving?.accountBalance = _flexIdToAccountBalance[flexSaving.id];
    return flexSaving;
  }

  Stream<Resource<FlexSaving>> enableFlexSaving(int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.enableFlexSavings(
            EnableFlexRequestBody(customerId: "$customerId", flexVersion: "0.0.1")
        )
    );
  }

  Stream<Resource<FlexTopUpResponse>> topUpFlex(FlexTopUpRequest request) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.doFlexTopUp(request)
    );
  }

  Stream<Resource<FlexTopUpResponse>> withdraw(FlexTopUpRequest request) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.withdraw(request)
    );
  }

  Stream<Resource<FlexWithdrawalCount>> getFreeWithdrawalCount(int flexSavingId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          final data = PreferenceUtil.getDataForLoggedInUser(FLEX_WITHDRAWAL_COUNT_KEY);
          if(data == null) return Stream.value(null);
          return Stream.value(FlexWithdrawalCount.fromJson(data));
        },
        fetchFromRemote: () => this._service.getFreeWithdrawalCount(
            FlexFreeWithdrawalCountRequest(flexSavingsAccountId: flexSavingId)
        ),
        saveRemoteData: (data) async {
          PreferenceUtil.saveDataForLoggedInUser(FLEX_WITHDRAWAL_COUNT_KEY, data);
        }
    );
  }

  PagingSource<int, FlexTransaction> getPageFlexTransactions(int flexSavingId, FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          final newOffset = offset * params.loadSize;
          return _flexTransactionDao.getFlexTransactions(flexSavingId, params.loadSize, newOffset).map((event) {
            return Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null);
          });
        },
        remoteMediator: _TransactionRemoteMediator(
            _service, _flexTransactionDao, flexSavingId
        )..filterResults = filterResult
    );
  }

  Stream<Resource<FlexAccountBalance>> getFlexAccountBalance(int flexSavingId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getFlexAccountBalance(flexSavingId),
    );
  }

  Stream<Resource<TotalSavingsBalance>> getAllBalance(int customerId) {
    return networkBoundResource(
      fetchFromLocal: () => Stream.value(null),
      fetchFromRemote: () => this._service.getAllSavingsBalance(customerId),
      saveRemoteData: (data) async {
        _totalSavingsBalance = data;
        data.flexSavingBalanceList?.forEach((element) {
          _flexIdToAccountBalance[element.savingAccountId!] = element.accountBalance!;
        });
      }
    );
  }

}

class _TransactionRemoteMediator extends AbstractDataCollectionMediator<int, FlexTransaction> {

  final SavingsProductService _service;
  final FlexTransactionDao _flexTransactionDao;
  final int flexSavingId;
  FilterResults filterResults = FilterResults();

  _TransactionRemoteMediator(
      this._service,
      this._flexTransactionDao,
      this.flexSavingId
      );

  @override
  Future<void> clearDB(List<FlexTransaction> items) async {
    await _flexTransactionDao.deleteOldRecords(items.map((e) => e.transactionRef).toList());
  }

  @override
  Future<void> saveToDB(List<FlexTransaction> value) async {
    await _flexTransactionDao.insertItems(value.map((e) {
      e.flexSavingId = flexSavingId;
      return e;
    }).toList());
  }

  @override
  Future<ServiceResult<DataCollection<FlexTransaction>>> serviceCall(int page) {
    return _service.getTransactionsFilter(
        flexSavingId,
        filterResults.typesToString(),
        filterResults.startDate,
        filterResults.endDate,
        page,
        20
    );
  }

}
