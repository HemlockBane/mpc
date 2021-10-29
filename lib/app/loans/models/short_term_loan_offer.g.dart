// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanOffer _$ShortTermLoanOfferFromJson(Map<String, dynamic> json) {
  return ShortTermLoanOffer(
    name: json['name'] as String?,
    offerReference: json['offerReference'] as String?,
    currencyCode: json['currencyCode'] as String?,
    interestRateInPercentage: json['interestRateInPercentage'] as int?,
    maxLoanAmount: json['maxLoanAmount'] as int?,
    minLoanAmount: json['minLoanAmount'] as int?,
    tenorInDays: json['tenorInDays'] as int?,
    penaltyString: json['penaltyString'] as String?,
    termsAndConditionLink: json['termsAndConditionLink'] as String?,
    status: json['status'] as String?,
    expiresOn: json['expiresOn'] as String?,
  );
}

Map<String, dynamic> _$ShortTermLoanOfferToJson(ShortTermLoanOffer instance) =>
    <String, dynamic>{
      'name': instance.name,
      'offerReference': instance.offerReference,
      'currencyCode': instance.currencyCode,
      'interestRateInPercentage': instance.interestRateInPercentage,
      'maxLoanAmount': instance.maxLoanAmount,
      'minLoanAmount': instance.minLoanAmount,
      'tenorInDays': instance.tenorInDays,
      'penaltyString': instance.penaltyString,
      'termsAndConditionLink': instance.termsAndConditionLink,
      'status': instance.status,
      'expiresOn': instance.expiresOn,
    };
