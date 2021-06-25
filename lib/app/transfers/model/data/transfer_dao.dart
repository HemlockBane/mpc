
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class TransferDao extends MoniepointDao<SingleTransferTransaction> {

    @Query("SELECT * FROM transfer_transactions WHERE (dateAdded BETWEEN :startDate AND :endDate) ORDER BY dateAdded DESC LIMIT :limit OFFSET :myOffset")
    Stream<List<SingleTransferTransaction>> getSingleTransferTransactions(int startDate, int endDate, int myOffset, int limit);

    @Query("SELECT * FROM transfer_transactions WHERE history_id = :id")
    Future<SingleTransferTransaction?> getSingleTransferTransactionById(int id);

    @Query("DELETE FROM transfer_transactions")
    Future<void> deleteAll();

}