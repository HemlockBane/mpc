import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config_dao.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/transfer_request_body.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service.dart';
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

import 'data/single_transfer_transaction.dart';
import 'data/transfer_dao.dart';
import 'package:collection/collection.dart';

class TransferServiceDelegate with NetworkResource {
  late final TransferService _service;
  late final FeeVatConfigDao _feeVatConfigDao;
  late final TransferDao _transferDao;

  late final _TransferMediator remoteMediator;

  TransferServiceDelegate(
      TransferService service,
      TransferDao transferDao,
      FeeVatConfigDao feeVatConfigDao) {
    this._transferDao = transferDao;
    this._service = service;
    this._feeVatConfigDao = feeVatConfigDao;

    remoteMediator = _TransferMediator(_service, _transferDao);
  }

  Future<SingleTransferTransaction?> getSingleTransactionById(int id) {
    return _transferDao.getSingleTransferTransactionById(id);
  }

  Stream<Resource<FeeVatConfig>> getAllFeeAndVatConfigByType () {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _feeVatConfigDao.getFeeAndVatConfigByType(),
        fetchFromRemote: () =>_service.getAllFeeAndVatConfig(),
        processRemoteResponse: (response) {
          _feeVatConfigDao.deleteAndInsert([response.data!.result!]);
        }
    );
  }

  Stream<Resource<TransactionStatus>> doTransfer(TransferRequestBody transferRequestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.empty(),
        fetchFromRemote: () => _service.doInstantTransfer(transferRequestBody)
    );
  }

  PagingSource<int, SingleTransferTransaction> getTransferHistory(int customerId, FilterResults filterResult) {
    return PagingSource(
        localSource: (LoadParams params) {
          final offset = params.key ?? 0;
          return _transferDao.getSingleTransferTransactions(
              filterResult.startDate, filterResult.endDate, 0, params.loadSize
          ).map((event) => Page(event, params.key, event.length == params.loadSize ? offset + 1 : null));
        },
        remoteMediator: remoteMediator..filterResult = filterResult..customerId = customerId
    );
  }

}

class _TransferMediator extends AbstractDataCollectionMediator<int, SingleTransferTransaction> {

  final TransferService _service;
  final TransferDao _transferDao;

  int customerId = 0;
  FilterResults filterResult = FilterResults();

  _TransferMediator(this._service, this._transferDao);

  @override
  Future<void> clearDB(List<SingleTransferTransaction> items) async {
    return this._transferDao.deleteAll();
  }

  @override
  Future<void> saveToDB(List<SingleTransferTransaction> value) async {
    return this._transferDao.insertItems(value);
  }

  @override
  Future<ServiceResult<DataCollection<SingleTransferTransaction>>> serviceCall(page) {
    return _service.getSingleTransferHistory(
        customerId.toString(),
        HistoryRequestBody()
          ..paymentListMap = {
            "ONE_TIME": [Constants.SUCCESSFUL],
            "SCHEDULED": [Constants.SUCCESSFUL],
            "SUBSCRIPTION": [Constants.COMPLETED],
          }
          ..startDate = filterResult.startDate
          ..endDate = filterResult.endDate
          ..page = page
          ..pageSize = 20
    );
  }
}