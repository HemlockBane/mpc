import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/loan_repayment_confirmation.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_transaction_viewmodel.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LoanRepaymentViewModel extends BaseViewModel with LoanTransactionViewModel {

  @override
  void setAmount(double amount) {
    super.setAmount(amount);
    this.checkValidity();
  }

  @override
  void setRepaymentAccount(UserAccount? userAccount) {
    super.setRepaymentAccount(userAccount);
    this.checkValidity();
  }

  @override
  bool validityCheck() {
    return (this.amount ?? 0.00) >= 1 && repaymentAccount != null;
  }


  LoanRepaymentConfirmation getRepaymentConfirmation({required ShortTermLoanDetails loanDetails}){
    final confirmation = LoanRepaymentConfirmation(
      repaymentAmount: this.amount?.toInt(),
      repaymentAccount: this.repaymentAccount,
      loanDetails: loanDetails
    );
    return confirmation;
  }

  String? getAccountName(String? accountNumber) {
    return getCustomerAccountByAccountNumber(accountNumber)?.accountName;
  }

  String? getAccountNumber(String? accountNumber) {
    return getCustomerAccountByAccountNumber(accountNumber)?.accountNumber;
  }

  bool isValidAccount(String? accountNumber){
    if (accountNumber == null) return false;
    if (getAccountName(accountNumber) == null || getAccountNumber(accountNumber) == null){
      return false;
    }
    return true;

  }
}
