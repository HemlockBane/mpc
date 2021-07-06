
import 'dart:async';

import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

import 'airtime_beneficiary_service.dart';
import 'data/airtime_beneficiary.dart';
import 'data/airtime_beneficiary_dao.dart';

class AirtimeBeneficiaryServiceDelegate with NetworkResource {
  late final AirtimeBeneficiaryService _service;
  late final AirtimeBeneficiaryDao _beneficiaryDao;

  AirtimeBeneficiaryServiceDelegate(
      AirtimeBeneficiaryService service,
      AirtimeBeneficiaryDao beneficiaryDao) {
    this._service = service;
    this._beneficiaryDao = beneficiaryDao;
  }

  Stream<Resource<List<AirtimeBeneficiary>>> getFrequentBeneficiaries() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _beneficiaryDao.getFrequentBeneficiaries(5),
        fetchFromRemote: () => this._service.getFrequentBeneficiaries(),
        processRemoteResponse: (v) {
          _beneficiaryDao.insertItems(v.data!.result!);
        }
    );
  }

  PagingSource<int, AirtimeBeneficiary> getAirtimeBeneficiaries() {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.getPagedAirtimeBeneficiary(0, params.loadSize)
              .map((event) => Page(event, params.key, event.length == params.loadSize ? offset + 1 : null)
          );
        },
        remoteMediator: _AirtimeBeneficiaryMediator(_service, _beneficiaryDao)
    );
  }

  PagingSource<int, AirtimeBeneficiary> searchAirtimeBeneficiaries(String search) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.searchPagedAirtimeBeneficiary(search, offset * params.loadSize, params.loadSize)
              .map((event) => Page(event, params.key, event.length == params.loadSize ? offset + 1 : null)
          );
        },
        remoteMediator: _AirtimeBeneficiaryMediator(_service, _beneficiaryDao)
    );
  }

  Stream<Resource<bool>> deleteAirtimeBeneficiary(int beneficiaryId, int pin, int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.deleteBeneficiary(beneficiaryId, customerId, pin)
    );
  }

  Future<void> deleteLocalBeneficiary(AirtimeBeneficiary beneficiary) {
    return _beneficiaryDao.deleteItem(beneficiary);
  }

}

class _AirtimeBeneficiaryMediator extends AbstractDataCollectionMediator<int, AirtimeBeneficiary> {

  final AirtimeBeneficiaryService _service;
  final AirtimeBeneficiaryDao _airtimeBeneficiaryDao;

  _AirtimeBeneficiaryMediator(this._service, this._airtimeBeneficiaryDao);

  @override
  Future<void> clearDB(List<AirtimeBeneficiary> items) async {
    return this._airtimeBeneficiaryDao.deleteAll(items.map((e) => e.phoneNumber ?? "").toList());
  }

  @override
  Future<void> saveToDB(List<AirtimeBeneficiary> value) async {
    return this._airtimeBeneficiaryDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<AirtimeBeneficiary>>> serviceCall(page) {
    return _service.getAirtimeBeneficiaries(page: page, pageSize: 20);
  }
}


