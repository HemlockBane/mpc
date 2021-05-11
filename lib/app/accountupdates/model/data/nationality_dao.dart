import 'package:floor/floor.dart';
import 'package:moniepoint_flutter/core/database/moniepoint_dao.dart';

import '../drop_items.dart';

@dao
abstract class NationalityDao extends MoniepointDao<Nationality>{

  @Query('SELECT * FROM nationalities')
  Future<List<Nationality>> getNationalities();

}