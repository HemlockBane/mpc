import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';
import 'package:moniepoint_flutter/core/models/filter_results.dart';

import 'account_transaction.dart';

@dao
abstract class TransactionDao extends MoniepointDao<AccountTransaction> {

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> getTransactions(
      int customerAccountId,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionDate BETWEEN :startDate AND :endDate) "
          "AND (transactionChannel IN (:channels)) "
          "AND type IN (:transactionTypes) ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByAllCriteria(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> channels,
      List<String> transactionTypes,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionDate BETWEEN :startDate AND :endDate) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByDate(
      int customerAccountId,
      int startDate,
      int endDate,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionChannel IN (:channels)) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByChannels(
      int customerAccountId,
      List<String> channels,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND type IN (:transactionTypes) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByTypes(
      int customerAccountId,
      List<String> transactionTypes,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionDate BETWEEN :startDate AND :endDate) "
          "AND (transactionChannel IN (:channels)) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByDateAndChannels(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> channels,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionDate BETWEEN :startDate AND :endDate) "
          "AND type IN (:transactionTypes) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByDateAndTypes(
      int customerAccountId,
      int startDate,
      int endDate,
      List<String> transactionTypes,
      int limit,
      int myOffset
  );

  @Query(
      "SELECT * FROM account_transactions "
          "WHERE customerAccountId = :customerAccountId "
          "AND (transactionChannel IN (:channels)) "
          "AND type IN (:transactionTypes) "
          "ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset"
  )
  Stream<List<AccountTransaction>> filterTransactionByChannelsAndTypes(
      int customerAccountId,
      List<String> channels,
      List<String> transactionTypes,
      int limit,
      int myOffset
  );

  @Query("SELECT * FROM account_transactions WHERE transactionRef =:tranRef")
  Future<AccountTransaction?> getTransactionByRef(String tranRef);

  @Query("DELETE FROM account_transactions WHERE transactionRef NOT IN(:transactionRefs)")
  Future<void> deleteOldAccountTransactions(List<String> transactionRefs);

  @transaction
  Future<void> deleteAndInsert(List<AccountTransaction> items) async {
    await deleteOldAccountTransactions(items.map((e) => e.transactionRef).toList());
    await insertItems(items);
  }

  //@transaction
  Stream<List<AccountTransaction>> getPagedTransactions(
      int customerAccountId, FilterResults filterResult, int limit, int myOffset) {
    //Decide the type of filter we are doing
    switch(filterResult.getFilterResultType()) {
      case FilterResultType.DATE_ONLY:
        return filterTransactionByDate(
            customerAccountId,
            filterResult.startDate,
            filterResult.endDate,
            limit, myOffset
        );
      case FilterResultType.CHANNELS_ONLY:
        return filterTransactionByChannels(
            customerAccountId,
            filterResult.channels.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.TYPES_ONLY:
        return filterTransactionByTypes(
            customerAccountId,
            filterResult.types.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.DATE_AND_CHANNELS:
        return filterTransactionByDateAndChannels(
            customerAccountId,
            filterResult.startDate,
            filterResult.endDate,
            filterResult.channels.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.DATE_AND_TYPES:
        return filterTransactionByDateAndTypes(
            customerAccountId,
            filterResult.startDate,
            filterResult.endDate,
            filterResult.types.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.CHANNELS_AND_TYPES:
        return filterTransactionByChannelsAndTypes(
            customerAccountId,
            filterResult.channels.map((e) => describeEnum(e)).toList(),
            filterResult.types.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.ALL:
        return filterTransactionByAllCriteria(
            customerAccountId,
            filterResult.startDate,
            filterResult.endDate,
            filterResult.channels.map((e) => describeEnum(e)).toList(),
            filterResult.types.map((e) => describeEnum(e)).toList(),
            limit, myOffset
        );
      case FilterResultType.NONE:
        return getTransactions(customerAccountId, limit, myOffset);
      default:
        return getTransactions(customerAccountId, limit, myOffset);
    }
  }
}