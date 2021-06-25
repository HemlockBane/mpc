import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillHistoryDetailViewModel extends BaseViewModel {
  late final BillServiceDelegate _delegate;

  BillHistoryDetailViewModel({
    BillServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
  }

  Future<BillTransaction?> getSingleTransactionById(int historyId) {
    return _delegate.getSingleTransactionById(historyId);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId);
  }

}