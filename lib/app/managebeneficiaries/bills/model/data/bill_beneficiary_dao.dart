import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'bill_beneficiary.dart';

@dao
abstract class BillBeneficiaryDao extends MoniepointDao<BillBeneficiary>{

  @Query("SELECT * FROM bill_beneficiaries ORDER BY frequency DESC LIMIT :limit")
  Stream<List<BillBeneficiary>> getFrequentBeneficiaries(int limit);

  @Query("SELECT * FROM bill_beneficiaries ORDER BY frequency DESC LIMIT :limit OFFSET :myOffset")
  Stream<List<BillBeneficiary>> getPagedBillBeneficiary(int myOffset, int limit);

  @Query("SELECT * FROM bill_beneficiaries WHERE billerCode=:billerCode ORDER BY frequency DESC LIMIT :limit")
  Stream<List<BillBeneficiary>> getFrequentBeneficiariesByBiller(int limit, String billerCode);

  @Query("SELECT * FROM bill_beneficiaries WHERE name LIKE :search OR customerIdentity LIKE :search ORDER BY name ASC LIMIT :limit OFFSET :myOffset")
  Stream<List<BillBeneficiary>> searchPagedBillBeneficiary(String search, int myOffset, int limit);//: PagingSource<Int, TransferBeneficiary>


  // @Query("SELECT * FROM billbeneficiary ORDER BY frequency DESC")
  // abstract fun getPagedAirtimeBeneficiary(): PagingSource<Int, TransferBeneficiary>
  //
  // @Query("SELECT * FROM billbeneficiary WHERE accountName LIKE :search OR accountNumber LIKE :search  ORDER BY accountName ASC")
  // abstract fun searchPagedTransferBeneficiary(search:String?): PagingSource<Int, TransferBeneficiary>
  //
  @Query("DELETE FROM bill_beneficiaries WHERE customerIdentity NOT IN(:customerIds)")
  Future<void> deleteAll(List<String> customerIds);

}