import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_offer.dart';

part 'short_term_pending_loan_request.g.dart';

@JsonSerializable()
class ShortTermPendingLoanRequest {
  String? name;
  String? description;
  String? offerName;
  int? loanAmount;
  int? interestRate;
  int? interestAmount;
  int? tenor;
  int? totalRepayment;
  String? payoutAccount;
  String? repaymentAccount;
  ShortTermLoanOffer? shortTermLoanOffer;

  ShortTermPendingLoanRequest({
    this.name,
    this.description,
    this.offerName,
    this.loanAmount,
    this.interestRate,
    this.interestAmount,
    this.tenor,
    this.totalRepayment,
    this.payoutAccount,
    this.repaymentAccount,
    this.shortTermLoanOffer,
  });

  factory ShortTermPendingLoanRequest.fromJson(Object? data) =>
      _$ShortTermPendingLoanRequestFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermPendingLoanRequestToJson(this);
}
