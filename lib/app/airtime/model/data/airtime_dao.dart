import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'airtime_transaction.dart';

@dao
abstract class AirtimeDao extends MoniepointDao<AirtimeTransaction> {
  @Query("SELECT * FROM airtime_transactions WHERE (creationTimeStamp BETWEEN :startDate AND :endDate) ORDER BY creationTimeStamp DESC LIMIT :limit OFFSET :offset")
  Stream<List<AirtimeTransaction>> getAirtimeTransactions(int startDate, int endDate, int offset, int limit);

  @Query("SELECT * FROM airtime_transactions WHERE history_id =:id")
  Future<AirtimeTransaction?> getAirtimeTransactionById(int id);

  @Query("DELETE FROM airtime_transactions")
  Future<void> deleteAll();
}