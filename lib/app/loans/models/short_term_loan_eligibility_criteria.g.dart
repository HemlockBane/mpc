// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_eligibility_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanEligibilityCriteria _$ShortTermLoanEligibilityCriteriaFromJson(
    Map<String, dynamic> json) {
  return ShortTermLoanEligibilityCriteria(
    passedCriteria: json['passedCriteria'] as List<dynamic>?,
    failedCriteria: json['failedCriteria'] as List<dynamic>?,
    isEligible: json['eligible'] as bool?,
  );
}

Map<String, dynamic> _$ShortTermLoanEligibilityCriteriaToJson(
        ShortTermLoanEligibilityCriteria instance) =>
    <String, dynamic>{
      'passedCriteria': instance.passedCriteria,
      'failedCriteria': instance.failedCriteria,
      'eligible': instance.isEligible,
    };
