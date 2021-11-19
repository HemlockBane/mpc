import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillHistoryDetailViewModel extends BaseViewModel {
  late final BillServiceDelegate _delegate;
  late final FileManagementServiceDelegate _fileServiceDelegate;

  BillHistoryDetailViewModel({
    BillServiceDelegate? delegate,
    FileManagementServiceDelegate? fileServiceDelegate
  }) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
    this._fileServiceDelegate = fileServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  Future<BillTransaction?> getSingleTransactionById(int historyId) {
    return _delegate.getSingleTransactionById(historyId);
  }

  Stream<Uint8List> downloadReceipt(int batchId){
    return _delegate.downloadReceipt(customerId.toString(), batchId);
  }

  Stream<Resource<FileResult>> getFile(String fileUUID) {
    return _fileServiceDelegate.getFileByUUID(fileUUID);
  }

}