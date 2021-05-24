import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class AirtimeServiceProviderDao extends MoniepointDao<AirtimeServiceProvider>{

  @Query("SELECT * FROM service_providers ORDER BY name ASC")
  Stream<List<AirtimeServiceProvider>> getAirtimeServiceProviders();

}