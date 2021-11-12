// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_request_confirmation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanRequestConfirmation _$LoanRequestConfirmationFromJson(
    Map<String, dynamic> json) {
  return LoanRequestConfirmation(
    loanAmount: (json['loanAmount'] as num?)?.toDouble(),
    totalRepayment: (json['totalRepayment'] as num?)?.toDouble(),
    interestAmount: (json['interestAmount'] as num?)?.toDouble(),
    repaymentAccount: json['repaymentAccount'] == null
        ? null
        : UserAccount.fromJson(json['repaymentAccount'] as Object),
    payoutAccount: json['payoutAccount'] == null
        ? null
        : UserAccount.fromJson(json['payoutAccount'] as Object),
    loanOffer: json['loanOffer'] == null
        ? null
        : AvailableShortTermLoanOffer.fromJson(json['loanOffer'] as Object),
  );
}

Map<String, dynamic> _$LoanRequestConfirmationToJson(
        LoanRequestConfirmation instance) =>
    <String, dynamic>{
      'loanAmount': instance.loanAmount,
      'interestAmount': instance.interestAmount,
      'totalRepayment': instance.totalRepayment,
      'loanOffer': instance.loanOffer,
      'payoutAccount': instance.payoutAccount,
      'repaymentAccount': instance.repaymentAccount,
    };
