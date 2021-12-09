import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/savings/model/savings_product_service_delegate.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_request.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_top_up_response.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_withdrawal_count.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/savings_view_model.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';


class SavingsFlexWithdrawalViewModel extends BaseViewModel with SavingsViewModel{
  late final SavingsProductServiceDelegate _flexProductDelegate;

  SavingsFlexWithdrawalViewModel({SavingsProductServiceDelegate? productServiceDelegate}) {
    this._flexProductDelegate = productServiceDelegate ?? GetIt.I<SavingsProductServiceDelegate>();
  }

  @override
  bool validityCheck() {
    return (this.amount ?? 0.00) >= 1 && sourceAccount != null && flexSavingAccount != null;
  }

  Future<FlexSaving?> getFlexSaving(int flexSavingId) async {
    final flexSaving = await _flexProductDelegate.getSingleFlexSaving(flexSavingId);
    setFlexSavingAccount(flexSaving);
    await for(var response in _flexProductDelegate.getFreeWithdrawalCount(flexSavingId)) {
      if(response is Loading<FlexWithdrawalCount> && response.data != null) {
        flexSaving?.withWithdrawalCount(response.data);
        break;
      }
      if(response is Success) {
        flexSaving?.withWithdrawalCount(response.data);
        break;
      }
      if(response is Error) break;
    }
    return flexSaving;
  }

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  void setSourceAccount(UserAccount? userAccount) {
    super.setSourceAccount(userAccount);
    this.checkValidity();
  }

  Stream<Resource<FlexTopUpResponse>> withdraw() {
    final request = FlexTopUpRequest()
      ..flexSavingAccountId = flexSavingAccount?.id
      ..customerAccountId = sourceAccount?.customerAccount?.id
      ..amount = amount;
    return _flexProductDelegate.withdraw(request);
  }

  @override
  void dispose() {
    super.dispose();
  }


}