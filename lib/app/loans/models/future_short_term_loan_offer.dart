import 'package:json_annotation/json_annotation.dart';

part 'future_short_term_loan_offer.g.dart';

@JsonSerializable()
class FutureShortTermLoanOffer {
  String? offerName;
  int? maximumAmount;
  double? minInterestRate;
  int? maxPeriod;
  String? eligibilityString;


  FutureShortTermLoanOffer({
    this.offerName,
    this.maximumAmount,
    this.minInterestRate,
    this.maxPeriod,
    this.eligibilityString,
  });
  factory FutureShortTermLoanOffer.fromJson(Object? data) =>
    _$FutureShortTermLoanOfferFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$FutureShortTermLoanOfferToJson(this);
}