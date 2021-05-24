
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class TransferDao extends MoniepointDao<SingleTransferTransaction> {

    @Query("SELECT * FROM transfer_transactions WHERE (dateAdded BETWEEN :startDate AND :endDate) ORDER BY dateAdded DESC")
    Stream<List<SingleTransferTransaction>> getSingleTransferTransactions(int startDate, int endDate);

    @Query("DELETE FROM transfer_transactions")
    Future<void> deleteAll();

}