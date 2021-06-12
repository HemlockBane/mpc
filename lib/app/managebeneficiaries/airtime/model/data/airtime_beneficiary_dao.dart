import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import 'airtime_beneficiary.dart';

@dao
abstract class AirtimeBeneficiaryDao extends MoniepointDao<AirtimeBeneficiary>{

  @Query("SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT :limit")
  Stream<List<AirtimeBeneficiary>> getFrequentBeneficiaries(int limit);

  @Query("SELECT * FROM airtime_beneficiaries ORDER BY frequency DESC LIMIT :limit OFFSET :myOffset")
  Stream<List<AirtimeBeneficiary>> getPagedAirtimeBeneficiary(int myOffset, int limit);

  @Query("SELECT * FROM airtime_beneficiaries WHERE name LIKE :search OR phoneNumber LIKE :search ORDER BY name ASC LIMIT :limit OFFSET :myOffset")
  Stream<List<AirtimeBeneficiary>> searchPagedAirtimeBeneficiary(String search, int myOffset, int limit);

  @Query("DELETE FROM airtime_beneficiaries WHERE phoneNumber NOT IN(:phoneNumbers)")
  Future<void> deleteAll(List<String> phoneNumbers);

}