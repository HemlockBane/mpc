
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'loan_repayment_confirmation.g.dart';

@JsonSerializable()
class LoanRepaymentConfirmation{
  int? repaymentAmount;
  UserAccount? repaymentAccount;
  ShortTermLoanDetails? loanDetails;

  LoanRepaymentConfirmation({
    required this.repaymentAmount,
    required this.repaymentAccount,
    required this.loanDetails
  });

  factory LoanRepaymentConfirmation.fromJson(Object? data) =>
    _$LoanRepaymentConfirmationFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$LoanRepaymentConfirmationToJson(this);

}