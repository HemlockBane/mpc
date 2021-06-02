import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';



@dao
abstract class TransferBeneficiaryDao extends MoniepointDao<TransferBeneficiary>{

  @Query("SELECT * FROM transfer_beneficiaries ORDER BY frequency DESC LIMIT :limit")
  Stream<List<TransferBeneficiary>> getFrequentBeneficiaries(int limit);

  @Query("SELECT * FROM transfer_beneficiaries ORDER BY frequency DESC LIMIT :limit OFFSET :offset")
  Stream<List<TransferBeneficiary>> getPagedTransferBeneficiary(int offset, int limit);

  // @Query("SELECT * FROM transferbeneficiary ORDER BY frequency DESC")
  // abstract fun getPagedTransferBeneficiary(): PagingSource<Int, TransferBeneficiary>
  //
  // @Query("SELECT * FROM transferbeneficiary WHERE accountName LIKE :search OR accountNumber LIKE :search  ORDER BY accountName ASC")
  // abstract fun searchPagedTransferBeneficiary(search:String?): PagingSource<Int, TransferBeneficiary>
  //
  @Query("DELETE FROM transfer_beneficiaries WHERE accountNumber NOT IN(:accountNumbers)")
  Future<void> deleteAll(List<String> accountNumbers);

}