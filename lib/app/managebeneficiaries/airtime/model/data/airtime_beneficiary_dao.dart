import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'airtime_beneficiary.dart';

@dao
abstract class AirtimeBeneficiaryDao extends MoniepointDao<AirtimeBeneficiary>{

  @Query("SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT :limit")
  Stream<List<AirtimeBeneficiary>> getFrequentBeneficiaries(int limit);

  @Query("SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT :limit OFFSET :offset")
  Stream<List<AirtimeBeneficiary>> getPagedAirtimeBeneficiary(int offset, int limit);

  // @Query("SELECT * FROM airtimebeneficiary ORDER BY frequency DESC")
  // abstract fun getPagedAirtimeBeneficiary(): PagingSource<Int, TransferBeneficiary>
  //
  // @Query("SELECT * FROM airtimebeneficiary WHERE accountName LIKE :search OR accountNumber LIKE :search  ORDER BY accountName ASC")
  // abstract fun searchPagedTransferBeneficiary(search:String?): PagingSource<Int, TransferBeneficiary>
  //
  @Query("DELETE FROM airtime_beneficiaries WHERE phoneNumber NOT IN(:phoneNumbers)")
  Future<void> deleteAll(List<String> phoneNumbers);

}