// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'short_term_loan_product_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortTermLoanProductStatus _$ShortTermLoanProductStatusFromJson(
    Map<String, dynamic> json) {
  return ShortTermLoanProductStatus(
    status: json['status'] as String?,
    shortTermLoanDetails: json['shortTermLoanDetails'] == null
        ? null
        : ShortTermLoanDetails.fromJson(json['shortTermLoanDetails'] as Object),
    shortTermPendingLoanRequest: json['shortTermPendingLoanRequest'] == null
        ? null
        : ShortTermPendingLoanRequest.fromJson(
            json['shortTermPendingLoanRequest'] as Object),
    shortTermLoanAdvert: json['shortTermLoanAdvert'] == null
        ? null
        : ShortTermLoanAdvert.fromJson(json['shortTermLoanAdvert'] as Object),
    isProductActive: json['productActive'] as bool?,
  );
}

Map<String, dynamic> _$ShortTermLoanProductStatusToJson(
        ShortTermLoanProductStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'shortTermLoanDetails': instance.shortTermLoanDetails,
      'shortTermPendingLoanRequest': instance.shortTermPendingLoanRequest,
      'shortTermLoanAdvert': instance.shortTermLoanAdvert,
      'productActive': instance.isProductActive,
    };
