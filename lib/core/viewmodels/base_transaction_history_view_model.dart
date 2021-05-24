// import 'package:moniepoint_flutter/core/models/filter_results.dart';
// import 'package:moniepoint_flutter/core/models/transaction.dart';
// import 'package:moniepoint_flutter/core/paging/paging_data.dart';
// import 'package:moniepoint_flutter/core/paging/paging_source.dart';
// import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
//
// abstract class BaseTransactionHistoryViewModel<DataType extends Transaction> extends BaseViewModel {
//
//   FilterResults filterResults = FilterResults.defaultFilter();
//   FilterResults previousFilter = FilterResults.defaultFilter();
//   PagingData<DataType>? cachedData;
//
//   PagingSource<int, DataType> fetchNewData(FilterResults filterResults);
//   List<String> getFilterItems();
//
//   PagingSource<int, DataType> getPagedHistoryTransaction() {
//   final isSameFilter = previousFilter.matches(filterResults, INVALIDATE_TIME, false)
//
//   if (isSameFilter && cachedData != null) return cachedData!
//
//   previousFilter.cloneFrom(filterResults)
//
//   final newData = fetchNewData(filterResults).;
//
//   cachedData = newData
//
//   return newData
//   }
//
//   /**
//    * Set the start and end date to the transactions
//    *
//    * The start and end date will be used on the next call to
//    * BaseTransactionHistoryViewModel#getPagedHistoryTransaction
//    */
//   fun setStartAndEndDate(startDate:Long, endDate:Long) {
//   filterResults.fromDate = startDate
//   filterResults.toDate = endDate
//   }
//
//   fun setChannels(channels: Set<TransactionChannel>) {
//   if(channels.isEmpty()) {
//   filterResults.channels.clear()
//   } else {
//   filterResults.addChannel(*channels.toTypedArray())
//   }
//   }
//
//   fun setTransactionType(transactionTypes: Set<TransactionType>) {
//   if(transactionTypes.isEmpty()) {
//   filterResults.transactionTypes.clear()
//   } else {
//   filterResults.addTransactionType(*transactionTypes.toTypedArray())
//   }
//   }
//
//   /**
//    * Exposes the filterResult to be used publicly
//    *
//    * The list(channels, transactionTypes) are modifiable publicly
//    * e.g if used with the filterHandler, selections and removals will be done
//    * directly on the list
//    */
//   fun getFilterResults(): FilterResults = this.filterResults
//
//   fun resetFilter() {
//   val currentTime = System.currentTimeMillis()
//   val diff = abs(currentTime - filterResults.toDate)
//   //if the diff is close to a day use currentTime to reset filter
//   setStartAndEndDate(0L, if(diff >= 86100000L) currentTime else filterResults.toDate)
//   setChannels(emptySet())
//   setTransactionType(emptySet())
//   }
//
//   fun isFilteredList(): Boolean {
//   return filterResults.channels.isNotEmpty() // did we filter by channels
//   || filterResults.transactionTypes.isNotEmpty()  // did we filter by transaction types
//   || filterResults.fromDate > 0L //did we filter by date
//   }
//
//   companion object {
//   const val INVALIDATE_TIME = 60000L
//   }
//
// }