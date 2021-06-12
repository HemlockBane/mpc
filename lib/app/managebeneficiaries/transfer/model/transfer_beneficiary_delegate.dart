
import 'dart:async';
import 'dart:convert';

import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary_dao.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/transfer_beneficiary_service.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_dao.dart';
import 'package:moniepoint_flutter/core/models/data_collection.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_result.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_data_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/helper/abstract_remote_mediator.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';

class TransferBeneficiaryServiceDelegate with NetworkResource {
  late final TransferBeneficiaryService _service;
  late final TransferBeneficiaryDao _beneficiaryDao;


  TransferBeneficiaryServiceDelegate(
      TransferBeneficiaryService service,
      TransferBeneficiaryDao beneficiaryDao) {
    this._service = service;
    this._beneficiaryDao = beneficiaryDao;
  }

  Stream<Resource<List<TransferBeneficiary>>> getFrequentBeneficiaries() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _beneficiaryDao.getFrequentBeneficiaries(5),
        fetchFromRemote: () => this._service.getFrequentBeneficiaries(),
        processRemoteResponse: (v) {
          _beneficiaryDao.insertItems(v.data!.result!);
        }
    );
  }

  PagingSource<int, TransferBeneficiary> getTransferBeneficiaries() {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.getPagedTransferBeneficiary(offset * params.loadSize, params.loadSize)
              .map((event) => Page(event, params.key, event.length == params.loadSize ? offset + 1 : null)
          );
        },
        remoteMediator: _TransferBeneficiaryMediator(_service, _beneficiaryDao)
    );
  }

  PagingSource<int, TransferBeneficiary> searchTransferBeneficiaries(String search) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _beneficiaryDao.searchPagedTransferBeneficiary(search,offset * params.loadSize, params.loadSize)
              .map((event) {
                print(jsonEncode(event));
                return Page(event, params.key, event.length == params.loadSize ? offset + 1 : null);
              }
          );
        },
        remoteMediator: _TransferBeneficiaryMediator(_service, _beneficiaryDao)
    );
  }

  Stream<Resource<bool>> deleteTransferBeneficiary(int beneficiaryId, int pin, int customerId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.deleteBeneficiary(beneficiaryId, customerId, pin)
    );
  }

}

class _TransferBeneficiaryMediator extends AbstractDataCollectionMediator<int, TransferBeneficiary> {

  final TransferBeneficiaryService _service;
  final TransferBeneficiaryDao _transferBeneficiaryDao;

  _TransferBeneficiaryMediator(this._service, this._transferBeneficiaryDao);

  @override
  Future<void> clearDB(List<TransferBeneficiary> items) async {
    return this._transferBeneficiaryDao.deleteAll(items.map((e) => e.accountNumber).toList());
  }

  @override
  Future<void> saveToDB(List<TransferBeneficiary> value) async {
    return this._transferBeneficiaryDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<TransferBeneficiary>>> serviceCall(page) {
    return _service.getAccountBeneficiaries(page: page, pageSize: 20);
  }
}


