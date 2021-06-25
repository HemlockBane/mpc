import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class TransferDetailViewModel extends BaseViewModel {
  late final TransferServiceDelegate _delegate;

  TransferDetailViewModel({
    TransferServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<TransferServiceDelegate>();
  }

  Future<SingleTransferTransaction?> getSingleTransactionById(int id) {
    return _delegate.getSingleTransactionById(id);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId);
  }

}