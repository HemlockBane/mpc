
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class FlexSavingsDao extends MoniepointDao<FlexSaving> {

  @Query('SELECT * FROM flex_savings ORDER BY createdOn DESC')
  Stream<List<FlexSaving>> getFlexSavings();

  @Query("SELECT * FROM flex_savings WHERE id = :id")
  Future<FlexSaving?> getFlexSavingById(int id);

  @Query('DELETE FROM flex_savings')
  Future<void> deleteAll();

  @Query("DELETE FROM flex_savings WHERE id NOT IN(:ids)")
  Future<void> deleteOldRecords(List<int> ids);

}