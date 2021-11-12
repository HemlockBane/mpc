import 'package:json_annotation/json_annotation.dart';

part 'short_term_loan_request.g.dart';

@JsonSerializable()
class ShortTermLoanRequest {
  int? loanAmount;
  String? loanOfferReference;
  @JsonKey(name: "payoutAccount")
  String? payoutAccountNumber;
  @JsonKey(name: "repaymentAccount")
  String? repaymentAccountNumber;

  ShortTermLoanRequest({
    this.loanAmount,
    this.loanOfferReference,
    this.payoutAccountNumber,
    this.repaymentAccountNumber,
  });

  factory ShortTermLoanRequest.fromJson(Object? data) =>
    _$ShortTermLoanRequestFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanRequestToJson(this);
}
