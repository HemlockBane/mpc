import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'bill_transaction.dart';
import 'biller.dart';
import 'biller_category.dart';
import 'biller_product.dart';

@dao
abstract class BillsDao extends MoniepointDao<BillTransaction> {

  @Query('SELECT * FROM bill_transactions WHERE (transactionTime BETWEEN :startDate AND :endDate) AND transactionStatus != "CANCELLED" ORDER BY transactionTime DESC LIMIT :limit OFFSET :myOffset')
  Stream<List<BillTransaction>> getBillTransactions(int startDate, int endDate,int myOffset, int limit);

  @Query("SELECT * FROM bill_transactions WHERE id = :id")
  Future<BillTransaction?> getBillTransactionById(int id);

  @Query('DELETE FROM bill_transactions')
  Future<void> deleteAll();

}

@dao
abstract class BillerDao extends MoniepointDao<Biller> {
  @Query("SELECT * FROM billers WHERE billerCategoryCode =:categoryId")
  Stream<List<Biller>> getBillersForCategory(String categoryId);

  @Query("SELECT * FROM billers WHERE billerCategoryCode=:categoryId AND name LIKE :billerName")
  Stream<List<Biller>> searchBillerByCategoryIdAndName(String categoryId, String billerName);

  @Query("DELETE FROM billers WHERE billerCategoryCode=:categoryId")
  Future<void> deleteByCategory(String categoryId);
}

@dao
abstract class BillerCategoryDao extends MoniepointDao<BillerCategory> {
  @Query("SELECT * FROM biller_categories")
  Stream<List<BillerCategory>> getAllBillerCategories();

  @Query('DELETE FROM biller_categories')
  Future<void> deleteAll();
}

@dao
abstract class BillerProductDao extends MoniepointDao<BillerProduct>{
  @Query("SELECT * FROM biller_products WHERE billerCode =:billerCode")
  Stream<List<BillerProduct>> getProductsByBiller(String billerCode);

  @Query("DELETE FROM biller_products WHERE billerCode =:billerCode AND (paymentCode NOT IN (:paymentCodes) OR id NOT IN(:ids))")
  Future<void> deleteByBiller(String billerCode, List<String> paymentCodes, List<int> ids);
}