import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/fee_vat_config.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

@dao
abstract class FeeVatConfigDao extends MoniepointDao<FeeVatConfig> {
  @Query('SELECT * FROM fee_vat_configs WHERE chargeType ="BOUNDED"')
  Stream<FeeVatConfig?> getFeeAndVatConfigByType();

  @Query('DELETE FROM fee_vat_configs')
  Future<void> deleteAllConfig();

  @transaction
  Future<void> deleteAndInsert(List<FeeVatConfig> items) async {
    await deleteAllConfig();
    await insertItems(items);
  }
}