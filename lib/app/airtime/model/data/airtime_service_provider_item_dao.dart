import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class AirtimeServiceProviderItemDao extends MoniepointDao<AirtimeServiceProviderItem>{

  @Query("SELECT * FROM service_provider_items WHERE billerId=:billerId")
  Stream<List<AirtimeServiceProviderItem>> getServiceProviderItems(String billerId);

  @Query("DELETE FROM service_provider_items WHERE billerId=:billerId AND paymentCode NOT IN(:codes)")
  Future<void> deleteProviderItemsByBillerId(String billerId, List<String> codes);

}