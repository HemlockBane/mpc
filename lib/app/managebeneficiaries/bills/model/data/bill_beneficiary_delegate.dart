import 'dart:async';

import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import '../bill_beneficiary_service.dart';
import 'bill_beneficiary.dart';
import 'bill_beneficiary_dao.dart';

class BillBeneficiaryServiceDelegate with NetworkResource {
  late final BillBeneficiaryService _service;
  late final BillBeneficiaryDao _beneficiaryDao;

  BillBeneficiaryServiceDelegate(
      BillBeneficiaryService service,
      BillBeneficiaryDao beneficiaryDao) {
    this._service = service;
    this._beneficiaryDao = beneficiaryDao;
  }

  PagingSource<int, BillBeneficiary> getBillBeneficiaries(int customerId) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.getPagedBillBeneficiary(0, params.loadSize)
              .map((event) => Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null)
          );
        },
      remoteMediator: _BillBeneficiaryMediator(_service, _beneficiaryDao)..customerId = customerId
    );
  }

  PagingSource<int, BillBeneficiary> searchBillBeneficiaries(int customerId, String search) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.searchPagedBillBeneficiary(search, offset * params.loadSize, params.loadSize)
              .map((event) => Page(event, params.key ?? 0, event.length == params.loadSize ? offset + 1 : null)
          );
        },
        remoteMediator: _BillBeneficiaryMediator(_service, _beneficiaryDao)..customerId = customerId
    );
  }

  Stream<Resource<List<BillBeneficiary>>> getFrequentBeneficiariesByBiller(int limit, String billerCode) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _beneficiaryDao.getFrequentBeneficiariesByBiller(limit, billerCode),
        fetchFromRemote: () => this._service.getFrequentBeneficiaries(100),
        processRemoteResponse: (v) {
          _beneficiaryDao.insertItems(v.data!.result!);
        }
    );
  }

  Stream<Resource<bool>> deleteBillBeneficiary(int beneficiaryId, int pin, int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.deleteBeneficiary(beneficiaryId, customerId, pin)
    );
  }

  Future<void> deleteLocalBeneficiary(BillBeneficiary beneficiary) {
    return _beneficiaryDao.deleteItem(beneficiary);
  }

}

class _BillBeneficiaryMediator extends AbstractDataCollectionMediator<int, BillBeneficiary> {

  final BillBeneficiaryService _service;
  final BillBeneficiaryDao _billBeneficiaryDao;

  int? customerId;

  _BillBeneficiaryMediator(this._service, this._billBeneficiaryDao);

  @override
  Future<void> clearDB(List<BillBeneficiary> items) async {
    return this._billBeneficiaryDao.deleteAll(items.map((e) => e.customerIdentity ?? "").toList());
  }

  @override
  Future<void> saveToDB(List<BillBeneficiary> value) async {
    return this._billBeneficiaryDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<BillBeneficiary>>> serviceCall(page) {
    return _service.getBillerBeneficiaries(customerId ?? 0, page, 500);
  }
}


