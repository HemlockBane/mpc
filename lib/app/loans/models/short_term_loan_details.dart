import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'short_term_loan_details.g.dart';

@JsonSerializable()
class ShortTermLoanDetails {
  String? name;
  String? description;
  String? offerName;
  int? loanAmount;
  int? interestRate;
  int? interestAmount;
  int? totalRepayment;
  int? penaltyAmount;
  int? amountPaid;
  int? outstandingAmount;
  int? tenor;
  DateTime? dateRequested;
  DateTime? dueDate;
  String? payoutAccount;
  String? repaymentAccount;
  int? overdueDays;
  @JsonKey(name: "overdue")
  bool? isOverdue;

  ShortTermLoanDetails({
    this.name,
    this.description,
    this.offerName,
    this.loanAmount,
    this.interestRate,
    this.interestAmount,
    this.totalRepayment,
    this.penaltyAmount,
    this.amountPaid,
    this.outstandingAmount,
    this.tenor,
    this.dateRequested,
    this.dueDate,
    this.payoutAccount,
    this.repaymentAccount,
    this.overdueDays,
    this.isOverdue,
  });

  factory ShortTermLoanDetails.fromJson(Object? data) =>
      _$ShortTermLoanDetailsFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanDetailsToJson(this);
}
