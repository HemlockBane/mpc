
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
  
  late final _AirtimeBeneficiaryMediator _airtimeBeneficiaryMediator;

  AirtimeBeneficiaryServiceDelegate(
      AirtimeBeneficiaryService service,
      AirtimeBeneficiaryDao beneficiaryDao) {
    this._service = service;
    this._beneficiaryDao = beneficiaryDao;

    _airtimeBeneficiaryMediator = _AirtimeBeneficiaryMediator(_service, _beneficiaryDao);
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
        remoteMediator: _airtimeBeneficiaryMediator
    );
  }

}

class _AirtimeBeneficiaryMediator extends AbstractDataCollectionMediator<int, AirtimeBeneficiary> {

  final AirtimeBeneficiaryService _service;
  final AirtimeBeneficiaryDao _transferBeneficiaryDao;

  _AirtimeBeneficiaryMediator(this._service, this._transferBeneficiaryDao);

  @override
  Future<void> clearDB(List<AirtimeBeneficiary> items) async {
    return this._transferBeneficiaryDao.deleteAll(items.map((e) => e.phoneNumber ?? "").toList());
  }

  @override
  Future<void> saveToDB(List<AirtimeBeneficiary> value) async {
    return this._transferBeneficiaryDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<AirtimeBeneficiary>>> serviceCall(page) {
    return _service.getAirtimeBeneficiaries(page: page, pageSize: 20);
  }
}


