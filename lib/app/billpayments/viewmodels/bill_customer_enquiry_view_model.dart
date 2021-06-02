import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/bill_service_delegate.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_validation_status.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class BillCustomerEnquiryViewModel extends BaseViewModel {
  late final BillServiceDelegate _delegate;

  BillCustomerEnquiryViewModel({
    BillServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<BillServiceDelegate>();
  }

  Stream<Resource<BillValidationStatus>> getBillCustomerBeneficiary(String customerId, String paymentCode) {
    return _delegate.validateCustomerBillPayment(customerId, paymentCode);
  }

  @override
  void dispose() {
    super.dispose();
  }
}