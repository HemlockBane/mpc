// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanDetails _$ShortTermLoanDetailsFromJson(Map<String, dynamic> json) {
  return ShortTermLoanDetails(
    name: json['name'] as String?,
    description: json['description'] as String?,
    offerName: json['offerName'] as String?,
    loanAmount: json['loanAmount'] as int?,
    interestRate: json['interestRate'] as int?,
    interestAmount: json['interestAmount'] as int?,
    totalRepayment: json['totalRepayment'] as int?,
    penaltyAmount: json['penaltyAmount'] as int?,
    amountPaid: json['amountPaid'] as int?,
    outstandingAmount: json['outstandingAmount'] as int?,
    tenor: json['tenor'] as int?,
    dateRequested: json['dateRequested'] == null
        ? null
        : DateTime.parse(json['dateRequested'] as String),
    dueDate: json['dueDate'] == null
        ? null
        : DateTime.parse(json['dueDate'] as String),
    payoutAccountNumber: json['payoutAccount'] as String?,
    repaymentAccountNumber: json['repaymentAccount'] as String?,
    overdueDays: json['overdueDays'] as int?,
    isOverdue: json['overdue'] as bool?,
  );
}

Map<String, dynamic> _$ShortTermLoanDetailsToJson(
        ShortTermLoanDetails instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'offerName': instance.offerName,
      'loanAmount': instance.loanAmount,
      'interestRate': instance.interestRate,
      'interestAmount': instance.interestAmount,
      'totalRepayment': instance.totalRepayment,
      'penaltyAmount': instance.penaltyAmount,
      'amountPaid': instance.amountPaid,
      'outstandingAmount': instance.outstandingAmount,
      'tenor': instance.tenor,
      'dateRequested': instance.dateRequested?.toIso8601String(),
      'dueDate': instance.dueDate?.toIso8601String(),
      'payoutAccount': instance.payoutAccountNumber,
      'repaymentAccount': instance.repaymentAccountNumber,
      'overdueDays': instance.overdueDays,
      'overdue': instance.isOverdue,
    };
