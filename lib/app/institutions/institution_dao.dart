
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class InstitutionDao extends MoniepointDao<AccountProvider> {

  @Query("SELECT * FROM account_providers")
  Stream<List<AccountProvider>> getAccountProviders();

  @Query("SELECT * FROM account_providers WHERE name LIKE :search ORDER BY name ASC")
  Stream<List<AccountProvider>> searchPageAccountProviders(String search);

  @Query("SELECT * FROM account_providers WHERE name LIKE :search ORDER BY name ASC LIMIT :limit")
  Stream<List<AccountProvider>> searchAccountProviders(int limit, String search);

}