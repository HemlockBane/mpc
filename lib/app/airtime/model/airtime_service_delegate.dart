
import 'dart:convert';

import 'package:moniepoint_flutter/app/airtime/model/airtime_service.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/airtime/model/data_top_up_service.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';
import 'package:moniepoint_flutter/core/models/history_request_body.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

import 'data/airtime_service_provider_item_dao.dart';

class AirtimeServiceDelegate with NetworkResource {
  late final AirtimeService _service;
  late final DataTopUpService _dataTopUpService;
  late final AirtimeDao _airtimeDao;
  late final AirtimeServiceProviderDao _serviceProviderDao;
  late final AirtimeServiceProviderItemDao _serviceProviderItemDao;

  late final _AirtimeMediator remoteMediator;

  AirtimeServiceDelegate(
      AirtimeService service,
      DataTopUpService dataTopUpService,
      AirtimeDao airtimeDao,
      AirtimeServiceProviderDao serviceProviderDao,
      AirtimeServiceProviderItemDao serviceProviderItemDao) {

    this._service = service;
    this._airtimeDao = airtimeDao;
    this._serviceProviderDao = serviceProviderDao;
    this._serviceProviderItemDao = serviceProviderItemDao;
    this._dataTopUpService = dataTopUpService;

    remoteMediator = _AirtimeMediator(_service, _airtimeDao);
  }

  Stream<Resource<TransactionStatus>> makePurchase(AirtimePurchaseRequestBody requestBody) {
    print(jsonEncode(requestBody));
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.buySingleAirtime(requestBody)
    );
  }

  PagingSource<int, AirtimeTransaction> getAirtimeHistory(FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _airtimeDao.getAirtimeTransactions(
              filterResult.startDate, filterResult.endDate, 0, params.loadSize
          ).map((event) => Page(event, params.key, event.length == params.loadSize ? offset + 1 : null));
        },
        remoteMediator: remoteMediator..filterResult = filterResult
    );
  }

  Stream<Resource<List<AirtimeServiceProvider>>> getServiceProviders() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _serviceProviderDao.getAirtimeServiceProviders(),
        fetchFromRemote: () => _service.getServiceProviders(),
        processRemoteResponse: (response) {
          _serviceProviderDao.insertItems(response.data?.result ?? []);
        }
    );
  }

  Stream<Resource<List<AirtimeServiceProvider>>> getDataServiceProviders() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _serviceProviderDao.getAirtimeServiceProviders(),
        fetchFromRemote: () => _dataTopUpService.getServiceProviders(),
        processRemoteResponse: (response) {
          _serviceProviderDao.insertItems(response.data?.result ?? []);
        }
    );
  }

  Stream<Resource<List<AirtimeServiceProviderItem>>> getServiceProviderItems(String billerId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _serviceProviderItemDao.getServiceProviderItems(billerId),
        fetchFromRemote: () => _dataTopUpService.getServiceProviderItems(billerId),
        processRemoteResponse: (response)  {
          final result = response.data?.result;
          _serviceProviderItemDao.deleteProviderItemsByBillerId(
              billerId,
              result?.map((e) => e.paymentCode!).toList() ?? []
          );
          result?.forEach((element) => element.billerId = billerId);
          _serviceProviderItemDao.insertItems(response.data?.result ?? []);
        }
    );
  }

}

class _AirtimeMediator extends AbstractDataCollectionMediator<int, AirtimeTransaction> {

  final AirtimeService _service;
  final AirtimeDao _airtimeDao;

  FilterResults filterResult = FilterResults();

  _AirtimeMediator(this._service, this._airtimeDao);

  @override
  Future<void> clearDB(List<AirtimeTransaction> items) async {
    return this._airtimeDao.deleteAll();
  }

  @override
  Future<void> saveToDB(List<AirtimeTransaction> value) async {
    return this._airtimeDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<AirtimeTransaction>>> serviceCall(page) {
    return _service.getSingleAirtimeHistory(
        HistoryRequestBody()
          ..startDate = filterResult.startDate
          ..endDate = filterResult.endDate
          ..page = page
          ..pageSize = 20
    );
  }
}