import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class FlexTransactionDao extends MoniepointDao<FlexTransaction> {

  @Query('SELECT * FROM $FLEX_TRANSACTION_TABLE'
      ' WHERE flexSavingId = :flexSavingId ORDER BY transactionDate DESC LIMIT :limit OFFSET :myOffset')
  Stream<List<FlexTransaction>> getFlexTransactions(int flexSavingId, int limit, int myOffset);

  @Query("SELECT * FROM $FLEX_TRANSACTION_TABLE WHERE transactionRef = :transactionReference")
  Future<FlexSaving?> getFlexTransactionByReference(String transactionReference);

  @Query('DELETE FROM $FLEX_TRANSACTION_TABLE')
  Future<void> deleteAll();

  @Query("DELETE FROM $FLEX_TRANSACTION_TABLE WHERE transactionRef NOT IN(:references)")
  Future<void> deleteOldRecords(List<String> references);

}