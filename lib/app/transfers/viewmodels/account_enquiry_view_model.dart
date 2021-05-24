import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accounts/model/account_service_delegate.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class AccountEnquiryViewModel extends BaseViewModel {
  late final AccountServiceDelegate _delegate;

  AccountEnquiryViewModel({
    AccountServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<AccountServiceDelegate>();
  }

  Stream<Resource<TransferBeneficiary>> getAccountBeneficiary(String bankCode, String accountNumber) {
    return _delegate.getAccountBeneficiary(bankCode, accountNumber);
  }

  @override
  void dispose() {
    super.dispose();
  }
}