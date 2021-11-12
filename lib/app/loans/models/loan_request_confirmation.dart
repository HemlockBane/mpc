import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_request.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/utils/date_util.dart';

part 'loan_request_confirmation.g.dart';

@JsonSerializable()
class LoanRequestConfirmation {
  double? loanAmount;
  double? interestAmount;
  double? totalRepayment;
  AvailableShortTermLoanOffer? loanOffer;
  UserAccount? payoutAccount;
  UserAccount? repaymentAccount;

  LoanRequestConfirmation({
    required this.loanAmount,
    required this.totalRepayment,
    required this.interestAmount,
    required this.repaymentAccount,
    required this.payoutAccount,
    required this.loanOffer
  });

  factory LoanRequestConfirmation.fromJson(Object? data) =>
    _$LoanRequestConfirmationFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LoanRequestConfirmationToJson(this);


  String? getDueDate(){
    if (this.loanOffer == null || this.loanOffer?.maxPeriod == null) return null;
    final dueDateTime = DateTime.now().add(Duration(days: loanOffer!.maxPeriod!));
    final formattedDate = DateFormat("MMM. yyyy").format(dueDateTime);
    final daySuffix = getDayOfMonthSuffix(dueDateTime.day);
    return "${dueDateTime.day}$daySuffix $formattedDate";
  }

  ShortTermLoanRequest getLoanRequest(){
    final loanRequest = ShortTermLoanRequest(
      loanAmount: this.loanAmount?.toInt(),
      loanOfferReference: this.loanOffer?.offerReference,
      payoutAccountNumber: this.payoutAccount?.customerAccount?.accountNumber,
      repaymentAccountNumber: this.repaymentAccount?.customerAccount?.accountNumber,
    );
    return loanRequest;
  }
}
