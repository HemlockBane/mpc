import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/airtime/model/airtime_service_delegate.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/transfer_service_delegate.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AirtimeHistoryDetailViewModel extends BaseViewModel {
  late final AirtimeServiceDelegate _delegate;

  AirtimeHistoryDetailViewModel({
    AirtimeServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<AirtimeServiceDelegate>();
  }

  Future<AirtimeTransaction?> getSingleTransactionById(int historyId) {
    return _delegate.getSingleTransactionById(historyId);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId, PurchaseType.AIRTIME);
  }

}