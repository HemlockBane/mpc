// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_short_term_loan_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableShortTermLoanOffer _$AvailableShortTermLoanOfferFromJson(
    Map<String, dynamic> json) {
  return AvailableShortTermLoanOffer(
    offerName: json['offerName'] as String?,
    offerReference: json['offerReference'] as String?,
    maximumAmount: json['maximumAmount'] as int?,
    minInterestRate: (json['minInterestRate'] as num?)?.toDouble(),
    maxPeriod: json['maxPeriod'] as int?,
    penaltyString: json['penaltyString'] as String?,
    termsAndConditions: json['termsAndConditions'] as String?,
  );
}

Map<String, dynamic> _$AvailableShortTermLoanOfferToJson(
        AvailableShortTermLoanOffer instance) =>
    <String, dynamic>{
      'offerName': instance.offerName,
      'offerReference': instance.offerReference,
      'maximumAmount': instance.maximumAmount,
      'minInterestRate': instance.minInterestRate,
      'maxPeriod': instance.maxPeriod,
      'penaltyString': instance.penaltyString,
      'termsAndConditions': instance.termsAndConditions,
    };
