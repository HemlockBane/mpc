
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class SchemeDao  extends MoniepointDao<Tier> {
  @Query("SELECT * FROM tiers ORDER BY id")
  Stream<List<Tier>> getSchemes();

  @Query("DELETE FROM tiers")
  Future<void> deleteAllTiers();

}