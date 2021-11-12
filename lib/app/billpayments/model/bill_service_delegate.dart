
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_dao.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_payment_request_body.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_validation_status.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
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

class BillServiceDelegate with NetworkResource {
  late final BillService _service;
  late final BillsDao _billsDao;
  late final BillerDao _billerDao;
  late final BillerCategoryDao _billerCategoryDao;
  late final BillerProductDao _billerProductDao;

  late final _BillHistoryMediator remoteMediator;

  BillServiceDelegate(
      BillService service,
      BillsDao billsDao,
      BillerDao billerDao,
      BillerCategoryDao billerCategoryDao,
      BillerProductDao billerProductDao,
      ) {

    this._service = service;
    this._billsDao = billsDao;
    this._billerDao = billerDao;
    this._billerCategoryDao = billerCategoryDao;
    this._billerProductDao = billerProductDao;

    remoteMediator = _BillHistoryMediator(_service, _billsDao);
  }

  Stream<Resource<List<BillerCategory>>> getBillCategories() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _billerCategoryDao.getAllBillerCategories(),
        fetchFromRemote: () => _service.getBillerCategories(),
        saveRemoteData: (response) async {
          await _billerCategoryDao.deleteAll();
          await _billerCategoryDao.insertItems(response);
        }
    );
  }

  Stream<Resource<List<Biller>>> getBillersForCategory(String categoryId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _billerDao.getBillersForCategory(categoryId),
        fetchFromRemote: () => _service.getBillersByCategory(categoryId),
        processRemoteResponse: (response) {
          response.data?.result?.forEach((element) { element.billerCategoryCode = categoryId; });
        },
        saveRemoteData: (response) async {
          await _billerDao.deleteByCategory(categoryId);
          await _billerDao.insertItems(response);
        }
    );
  }

  Stream<Resource<List<BillerProduct>>> getBillerProducts(String billerCode) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _billerProductDao.getProductsByBiller(billerCode),
        fetchFromRemote: () => _service.getProductsByBiller(billerCode),
        processRemoteResponse: (response) {
          response.data?.result?.forEach((element) { element.billerCode = billerCode; });
        },
        saveRemoteData: (response) async {
          if(response.isEmpty) return null;
          await _billerProductDao.deleteByBiller(
              billerCode, response.map((e) => e.paymentCode ?? "").toList(),
              response.map((e) => e.id).toList()
          );
          await _billerProductDao.insertItems(response);
        }
    );
  }

  Stream<Resource<BillValidationStatus>> validateCustomerBillPayment(String customerId, String paymentCode) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.validateCustomerBillPayment(customerId, paymentCode)
    );
  }

  Stream<Resource<TransactionStatus>> makePurchase(BillPaymentRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.paySingleBill(requestBody)
    );
  }

  PagingSource<int, BillTransaction> getBillHistory(FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _billsDao.getBillTransactions(
              filterResult.startDate, filterResult.endDate, offset * params.loadSize, params.loadSize,
          ).map((event) => Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null));
        },
        remoteMediator: _BillHistoryMediator(_service, _billsDao)..filterResult = filterResult
    );
  }

  Future<BillTransaction?> getSingleTransactionById(int id) {
    return _billsDao.getBillTransactionById(id);
  }

  Stream<Uint8List> downloadReceipt(String customerId, int batchId) async* {
    final a = (await _service.downloadTransferReceipt(customerId, batchId)) as ResponseBody;
    yield* a.stream;
  }

}

class _BillHistoryMediator extends AbstractDataCollectionMediator<int, BillTransaction> {

  final BillService _service;
  final BillsDao _billsDao;

  FilterResults filterResult = FilterResults();
  final List<String> _statusList = [Constants.COMPLETED, Constants.PENDING, Constants.SUCCESSFUL, Constants.FAILED];

  _BillHistoryMediator(this._service, this._billsDao);

  @override
  Future<void> clearDB(List<BillTransaction> items) async {
    return this._billsDao.deleteAll();
  }

  @override
  Future<void> saveToDB(List<BillTransaction> value) async {
    return this._billsDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<BillTransaction>>> serviceCall(page) {
    return _service.getBillHistory(
        HistoryRequestBody()
          ..statuses = _statusList
          ..startDate = filterResult.startDate
          ..endDate = filterResult.endDate
          ..page = page
          ..pageSize = 20
    );
  }
}
