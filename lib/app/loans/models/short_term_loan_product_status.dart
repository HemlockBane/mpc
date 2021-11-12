import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_advert.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_pending_loan_request.dart';

part 'short_term_loan_product_status.g.dart';

@JsonSerializable()
class ShortTermLoanProductStatus {
  String? status;
  ShortTermLoanDetails? shortTermLoanDetails;
  ShortTermPendingLoanRequest? shortTermPendingLoanRequest;
  ShortTermLoanAdvert? shortTermLoanAdvert;
  @JsonKey(name: "productActive")
  bool? isProductActive;

  ShortTermLoanProductStatus({
    this.status,
    this.shortTermLoanDetails,
    this.shortTermPendingLoanRequest,
    this.shortTermLoanAdvert,
    this.isProductActive,
  });

  factory ShortTermLoanProductStatus.fromJson(Object? data) =>
      _$ShortTermLoanProductStatusFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanProductStatusToJson(this);
}
