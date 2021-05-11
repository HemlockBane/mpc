
import 'package:floor/floor.dart';

abstract class MoniepointDao<T> {

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItem(T item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItems(List<T> item);

  @delete
  Future<void> deleteItems(List<T> item);

  @delete
  Future<void> deleteItem(T item);

}