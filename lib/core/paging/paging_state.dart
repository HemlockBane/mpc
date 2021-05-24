import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';

class PagingState<K, V> {
  final List<Page<K, V>> data;
  final int? anchorPosition;
  final PagingConfig pagingConfig;

  PagingState(this.data, this.pagingConfig, {this.anchorPosition});
}

enum LoadType {
  REFRESH, APPEND, PREPEND
}