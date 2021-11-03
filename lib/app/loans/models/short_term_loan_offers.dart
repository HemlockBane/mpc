

import 'package:json_annotation/json_annotation.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/future_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/core/database/type_converters.dart';

part 'short_term_loan_offers.g.dart';

@JsonSerializable()
class ShortTermLoanOffers {
  List<AvailableShortTermLoanOffer>? availableLoanOffers;
  List<FutureShortTermLoanOffer>? futureLoanOffers;

  ShortTermLoanOffers({
    this.availableLoanOffers,
    this.futureLoanOffers,
  });

  factory ShortTermLoanOffers.fromJson(Object? data) =>
    _$ShortTermLoanOffersFromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$ShortTermLoanOffersToJson(this);

}
