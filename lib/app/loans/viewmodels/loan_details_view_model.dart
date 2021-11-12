import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/core/utils/date_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LoanDetailsViewModel extends BaseViewModel {
  String? getFormattedDate(DateTime? dueDate) {
    if (dueDate == null) return null;
    final day = dueDate.day;
    final daySuffix = getDayOfMonthSuffix(day);
    final formattedString = DateFormat("MMM. yyyy").format(dueDate);
    return "$day$daySuffix $formattedString";
  }

  double? getRepaymentProgress(ShortTermLoanDetails? loanDetails) {
    if (loanDetails == null &&
        loanDetails?.outstandingAmount == null &&
        loanDetails?.totalRepayment == null) return null;
    final outstanding = loanDetails!.outstandingAmount!;
    final total = loanDetails.totalRepayment!;
    return (total - outstanding) / total;
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
