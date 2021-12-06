
import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class FlexSavingsDao extends MoniepointDao<FlexSaving> {

  @Query('SELECT * FROM $FLEX_SAVING_TABLE ORDER BY createdOn DESC')
  Stream<List<FlexSaving>> getFlexSavings();

  @Query("SELECT * FROM $FLEX_SAVING_TABLE WHERE id = :id")
  Future<FlexSaving?> getFlexSavingById(int id);

  @Query('DELETE FROM $FLEX_SAVING_TABLE')
  Future<void> deleteAll();

  @Query("DELETE FROM $FLEX_SAVING_TABLE WHERE id NOT IN(:ids)")
  Future<void> deleteOldRecords(List<int> ids);

}