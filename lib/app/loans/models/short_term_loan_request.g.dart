// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanRequest _$ShortTermLoanRequestFromJson(Map<String, dynamic> json) {
  return ShortTermLoanRequest(
    loanAmount: json['loanAmount'] as int?,
    loanOfferReference: json['loanOfferReference'] as String?,
    payoutAccountNumber: json['payoutAccount'] as String?,
    repaymentAccountNumber: json['repaymentAccount'] as String?,
  );
}

Map<String, dynamic> _$ShortTermLoanRequestToJson(
        ShortTermLoanRequest instance) =>
    <String, dynamic>{
      'loanAmount': instance.loanAmount,
      'loanOfferReference': instance.loanOfferReference,
      'payoutAccount': instance.payoutAccountNumber,
      'repaymentAccount': instance.repaymentAccountNumber,
    };
