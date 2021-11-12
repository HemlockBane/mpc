// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_repayment_confirmation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanRepaymentConfirmation _$LoanRepaymentConfirmationFromJson(
    Map<String, dynamic> json) {
  return LoanRepaymentConfirmation(
    repaymentAmount: json['repaymentAmount'] as int?,
    repaymentAccount: json['repaymentAccount'] == null
        ? null
        : UserAccount.fromJson(json['repaymentAccount'] as Object),
    loanDetails: json['loanDetails'] == null
        ? null
        : ShortTermLoanDetails.fromJson(json['loanDetails'] as Object),
  );
}

Map<String, dynamic> _$LoanRepaymentConfirmationToJson(
        LoanRepaymentConfirmation instance) =>
    <String, dynamic>{
      'repaymentAmount': instance.repaymentAmount,
      'repaymentAccount': instance.repaymentAccount,
      'loanDetails': instance.loanDetails,
    };
