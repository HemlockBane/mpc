// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_short_term_loan_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FutureShortTermLoanOffer _$FutureShortTermLoanOfferFromJson(
    Map<String, dynamic> json) {
  return FutureShortTermLoanOffer(
    offerName: json['offerName'] as String?,
    maximumAmount: json['maximumAmount'] as int?,
    minInterestRate: (json['minInterestRate'] as num?)?.toDouble(),
    maxPeriod: json['maxPeriod'] as int?,
    eligibilityString: json['eligibilityString'] as String?,
  );
}

Map<String, dynamic> _$FutureShortTermLoanOfferToJson(
        FutureShortTermLoanOffer instance) =>
    <String, dynamic>{
      'offerName': instance.offerName,
      'maximumAmount': instance.maximumAmount,
      'minInterestRate': instance.minInterestRate,
      'maxPeriod': instance.maxPeriod,
      'eligibilityString': instance.eligibilityString,
    };
