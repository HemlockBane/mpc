import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';

enum FilterResultType {
  DATE_ONLY,
  CHANNELS_ONLY,
  TYPES_ONLY,
  DATE_AND_CHANNELS,
  DATE_AND_TYPES,
  CHANNELS_AND_TYPES,
  ALL,
  NONE
}

class FilterResults {

  int startDate = 0;
  int endDate = DateTime.now().millisecondsSinceEpoch;
  Set<TransactionChannel> channels = {};
  Set<TransactionType> types = {};

  FilterResults();

  factory FilterResults.defaultFilter() => FilterResults()
    ..channels = {}
    ..startDate = 0
    ..endDate = DateTime.now().millisecondsSinceEpoch
    ..types = {};


  FilterResultType getFilterResultType() {
    final filterByDate = startDate > 0 || endDate != 0;
    final filterByChannels = channels.isNotEmpty;
    final filterByTypes = types.isNotEmpty;

    if(filterByDate && filterByChannels && filterByTypes) {
      return FilterResultType.ALL;
    }
    if(filterByDate && !filterByTypes && !filterByChannels) {
      return FilterResultType.DATE_ONLY;
    }
    if(filterByDate && filterByTypes && !filterByChannels) {
      return FilterResultType.DATE_AND_TYPES;
    }
    if(filterByDate && filterByChannels && !filterByTypes) {
      return FilterResultType.DATE_AND_CHANNELS;
    }
    if(filterByTypes && !filterByChannels && !filterByDate) {
      return FilterResultType.TYPES_ONLY;
    }
    if(filterByChannels && !filterByTypes && !filterByDate) {
      return FilterResultType.CHANNELS_ONLY;
    }
    if(filterByTypes && filterByChannels && !filterByDate) {
      return FilterResultType.CHANNELS_AND_TYPES;
    }

    return FilterResultType.NONE;
  }

  bool isFilterable() {
    return channels.isNotEmpty
        || types.isNotEmpty
        || startDate > 0
        || endDate != 0;
  }

  String? channelsToString({String delimiter = ",", String? defaultValue}) {
    if(channels.isEmpty) return defaultValue;
    return channels.map((e) => describeEnum(e)).join(delimiter);
  }

  String typesToString({String delimiter = ",", String defaultValue = "ALL"}) {
    if(types.isEmpty) return defaultValue;
    return types.map((e) => describeEnum(e)).join(delimiter);
  }

}