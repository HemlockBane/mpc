import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexEnableViewModel extends BaseViewModel {

  late final SavingsProductServiceDelegate _productServiceDelegate;
  late final FileManagementServiceDelegate _fileManagementServiceDelegate;

  bool _isEnablingFlex = false;
  bool get isEnablingFlex => _isEnablingFlex;

  SavingsFlexEnableViewModel({
    SavingsProductServiceDelegate? productServiceDelegate,
    FileManagementServiceDelegate? fileManagementServiceDelegate
  }) {
    this._productServiceDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
    this._fileManagementServiceDelegate = fileManagementServiceDelegate ?? GetIt.I<FileManagementServiceDelegate>();
  }

  Stream<Resource<FlexSaving>> enableFlexSavings() {
    return this._productServiceDelegate.enableFlexSaving(customerId);
  }

  void setIsEnablingFlex(bool isEnablingFlex) {
    this._isEnablingFlex = isEnablingFlex;
  }

  Stream<Resource<FileResult>> getFile(String fileUUID){
    return _fileManagementServiceDelegate.getFileByUUID(fileUUID, shouldFetchRemote: false);
  }

  @override
  void dispose() {
    super.dispose();
  }

}