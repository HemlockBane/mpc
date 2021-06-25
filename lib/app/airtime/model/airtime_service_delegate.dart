
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_request_body.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_dao.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/airtime/model/data_top_up_service.dart';
import 'package:moniepoint_flutter/core/constants.dart';
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
  }

  Stream<Resource<TransactionStatus>> makePurchase(AirtimePurchaseRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => (requestBody.dataTopUpRequest!=null)
            ? _dataTopUpService.buySingleData(requestBody)
            : _service.buySingleAirtime(requestBody)
    );
  }

  PagingSource<int, AirtimeTransaction> getAirtimeHistory(FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _airtimeDao.getAirtimeTransactions(
              filterResult.startDate, filterResult.endDate, offset * params.loadSize, params.loadSize
          ).map((event) => Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null));
        },
        remoteMediator: _AirtimeMediator(_service, _airtimeDao)..filterResult = filterResult
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
        processRemoteResponse: (response) {
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

  Future<AirtimeTransaction?> getSingleTransactionById(int id) {
    return _airtimeDao.getAirtimeTransactionById(id);
  }

  Stream<Uint8List> downloadReceipt(String customerId, int batchId, PurchaseType purchaseType) async* {
    final downloadTask = (purchaseType == PurchaseType.DATA)
        ? _dataTopUpService.downloadAirtimeDataReceipt(customerId, batchId)
        : _service.downloadAirtimeReceipt(customerId, batchId);
    final a = (await downloadTask) as ResponseBody;
    yield* a.stream;
  }

}

class _AirtimeMediator extends AbstractDataCollectionMediator<int, AirtimeTransaction> {

  final AirtimeService _service;
  final AirtimeDao _airtimeDao;

  FilterResults filterResult = FilterResults();
  final List<String> _statusList = [Constants.COMPLETED, Constants.PENDING, Constants.SUCCESSFUL];

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
          ..statuses = _statusList
          ..startDate = filterResult.startDate
          ..endDate = filterResult.endDate
          ..page = page
          ..pageSize = 20
    );
  }
}