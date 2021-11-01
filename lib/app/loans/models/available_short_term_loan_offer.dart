import 'package:json_annotation/json_annotation.dart';

part 'available_short_term_loan_offer.g.dart';

@JsonSerializable()
class AvailableShortTermLoanOffer {
  AvailableShortTermLoanOffer({
    this.offerName,
    this.offerReference,
    this.maximumAmount,
    this.minInterestRate,
    this.maxPeriod,
    this.penaltyString,
    this.termsAndConditions,
  });

  String? offerName;
  String? offerReference;
  int? maximumAmount;
  double? minInterestRate;
  int? maxPeriod;
  String? penaltyString;
  String? termsAndConditions;

  factory AvailableShortTermLoanOffer.fromJson(Object? data) =>
    _$AvailableShortTermLoanOfferFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$AvailableShortTermLoanOfferToJson(this);
}
