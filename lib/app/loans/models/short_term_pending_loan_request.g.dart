// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_pending_loan_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermPendingLoanRequest _$ShortTermPendingLoanRequestFromJson(
    Map<String, dynamic> json) {
  return ShortTermPendingLoanRequest(
    name: json['name'] as String?,
    description: json['description'] as String?,
    offerName: json['offerName'] as String?,
    loanAmount: json['loanAmount'] as int?,
    interestRate: json['interestRate'] as int?,
    interestAmount: json['interestAmount'] as int?,
    tenor: json['tenor'] as int?,
    totalRepayment: json['totalRepayment'] as int?,
    payoutAccount: json['payoutAccount'] as String?,
    repaymentAccount: json['repaymentAccount'] as String?,
    shortTermLoanOffer: json['shortTermLoanOffer'] == null
        ? null
        : ShortTermLoanOffer.fromJson(json['shortTermLoanOffer'] as Object),
  );
}

Map<String, dynamic> _$ShortTermPendingLoanRequestToJson(
        ShortTermPendingLoanRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'offerName': instance.offerName,
      'loanAmount': instance.loanAmount,
      'interestRate': instance.interestRate,
      'interestAmount': instance.interestAmount,
      'tenor': instance.tenor,
      'totalRepayment': instance.totalRepayment,
      'payoutAccount': instance.payoutAccount,
      'repaymentAccount': instance.repaymentAccount,
      'shortTermLoanOffer': instance.shortTermLoanOffer,
    };
