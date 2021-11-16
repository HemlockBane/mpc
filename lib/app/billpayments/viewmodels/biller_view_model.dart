import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillerViewModel extends BaseViewModel {

  late final BillServiceDelegate _delegate;

  BillerViewModel({
    BillServiceDelegate? delegate
  }) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
  }

  Stream<Resource<List<Biller>>> getBillersByCategoryId(String categoryId) {
    return _delegate.getBillersForCategory(categoryId);
  }

  Stream<Resource<List<Biller>>> searchBiller(String categoryId, String billerName) {
    return _delegate.searchBillerByCategoryAndName(categoryId, "%$billerName%");
  }

}