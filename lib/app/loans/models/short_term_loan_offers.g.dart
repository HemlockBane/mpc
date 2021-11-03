// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_offers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanOffers _$ShortTermLoanOffersFromJson(Map<String, dynamic> json) {
  return ShortTermLoanOffers(
    availableLoanOffers: (json['availableLoanOffers'] as List<dynamic>?)
        ?.map((e) => AvailableShortTermLoanOffer.fromJson(e as Object))
        .toList(),
    futureLoanOffers: (json['futureLoanOffers'] as List<dynamic>?)
        ?.map((e) => FutureShortTermLoanOffer.fromJson(e as Object))
        .toList(),
  );
}

Map<String, dynamic> _$ShortTermLoanOffersToJson(
        ShortTermLoanOffers instance) =>
    <String, dynamic>{
      'availableLoanOffers': instance.availableLoanOffers,
      'futureLoanOffers': instance.futureLoanOffers,
    };
