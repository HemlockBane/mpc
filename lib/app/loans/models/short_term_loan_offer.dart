import 'package:json_annotation/json_annotation.dart';

part 'short_term_loan_offer.g.dart';

@JsonSerializable()
class ShortTermLoanOffer {
  String? name;
  String? offerReference;
  String? currencyCode;
  int? interestRateInPercentage;
  int? maxLoanAmount;
  int? minLoanAmount;
  int? tenorInDays;
  String? penaltyString;
  String? termsAndConditionLink;
  String? status;
  String? expiresOn;

  ShortTermLoanOffer({
    this.name,
    this.offerReference,
    this.currencyCode,
    this.interestRateInPercentage,
    this.maxLoanAmount,
    this.minLoanAmount,
    this.tenorInDays,
    this.penaltyString,
    this.termsAndConditionLink,
    this.status,
    this.expiresOn,
  });

  factory ShortTermLoanOffer.fromJson(Object? data) =>
      _$ShortTermLoanOfferFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanOfferToJson(this);
}
