

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_category.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillCategoryViewModel extends BaseViewModel {

  late final BillServiceDelegate _delegate;

  BillCategoryViewModel({BillServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
  }

  Stream<Resource<List<BillerCategory>>> getCategories() {
    return _delegate.getBillCategories();
  }

}