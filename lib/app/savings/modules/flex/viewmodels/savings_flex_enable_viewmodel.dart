import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/services/file_management_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

///SavingsFlexEnableViewModel
///
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

  Stream<Resource<FlexSaving>> enableFlexSavings() async* {
    final stream = this._productServiceDelegate.enableFlexSaving(customerId);
    await for (var response in stream) {
      if(response is Loading || response is Error) yield response;
      if(response is Success) {
        yield* this._productServiceDelegate.getRunningFlexSavings(customerId).map((event) {
          if(event is Loading) return Resource.loading(null);
          return response;
        });
      }
    }
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