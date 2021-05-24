import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/remote_mediator.dart';

class PagingSource<Key, Value> {
  PagingSource({
    required this.localSource,
    this.remoteMediator
  });

  final Stream<Page<Key, Value>> Function() localSource;
  final RemoteMediator<Key, Value>? remoteMediator;
}