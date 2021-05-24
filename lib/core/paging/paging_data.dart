import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/core/paging/combined_load_state.dart';
import 'package:moniepoint_flutter/core/paging/load_state.dart';
import 'package:moniepoint_flutter/core/paging/paging_state.dart';

import 'load_states.dart';

class PagingData<T> {
  final List<T> data;
  final List<T>? oldList;
  final CombinedLoadStates? loadStates;
  PagingData(this.data, {this.oldList, this.loadStates});
}

class Page<Key, Value> {
  final List<Value> data;

  final Key? prevKey;

  final Key? nextKey;

  Page(this.data, this.prevKey, this.nextKey);


  PagingData<Value> toPagingData(LoadStates states) {
    return PagingData(data, loadStates: CombinedLoadStates(
        LoadState(true), LoadState(true), LoadState(true)
    ));
    // switch(loadType) {
    //   case LoadType.REFRESH : {
    //     return PagingData(data, loadStates: CombinedLoadStates(
    //         states.refresh, states.append, states.prepend,
    //     ));
    //   }
    //   case LoadType.APPEND:{
    //     return PagingData(data, loadStates: CombinedLoadStates(
    //         LoadState(true), LoadState(true), LoadState(true)
    //     ));
    //   }
    //   case LoadType.PREPEND: {
    //     return PagingData(data, loadStates: CombinedLoadStates(
    //         LoadState(true), LoadState(true), LoadState(true)
    //     ));
    //   }
    // }
  }
}