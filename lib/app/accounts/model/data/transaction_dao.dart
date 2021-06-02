import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'account_transaction.dart';

@dao
abstract class TransactionDao extends MoniepointDao<AccountTransaction> {

  @Query(
      "SELECT * FROM account_transactions WHERE (transactionDate BETWEEN :startDate AND :endDate) AND (transactionChannel IN (:channels) OR transactionChannel is null) AND type IN (:transactionTypes) ORDER BY transactionDate DESC LIMIT :limit OFFSET :offset"
  )
  Stream<List<AccountTransaction>> getTransactionsByFilter(int startDate,
      int endDate, List<String> channels,
      List<String> transactionTypes,
      int offset, int limit
  );

  @Query("SELECT * FROM account_transactions WHERE transactionRef =:tranRef")
  Future<AccountTransaction?> getTransactionByRef( String tranRef);

  @Query("DELETE FROM account_transactions WHERE transactionRef NOT IN(:transactionRefs)")
  Future<void> deleteOldAccountTransactions(List<String> transactionRefs);

  @transaction
  Future<void> deleteAndInsert(List<AccountTransaction> items) async {
    await deleteOldAccountTransactions(items.map((e) => e.transactionRef).toList());
    await insertItems(items);
  }
}