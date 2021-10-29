// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_advert.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanAdvert _$ShortTermLoanAdvertFromJson(Map<String, dynamic> json) {
  return ShortTermLoanAdvert(
    name: json['name'] as String?,
    description: json['description'] as String?,
    minInterestRate: json['minInterestRate'] as int?,
    maxAmount: json['maxAmount'] as int?,
    penaltyString: json['penaltyString'] as String?,
  );
}

Map<String, dynamic> _$ShortTermLoanAdvertToJson(
        ShortTermLoanAdvert instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'minInterestRate': instance.minInterestRate,
      'maxAmount': instance.maxAmount,
      'penaltyString': instance.penaltyString,
    };
