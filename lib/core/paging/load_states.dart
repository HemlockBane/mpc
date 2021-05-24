import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/core/paging/paging_state.dart';

import 'load_state.dart';

class LoadStates {
  LoadStates(this.refresh, this.append, this.prepend);

  final LoadState refresh;
  final LoadState append;
  final LoadState prepend;

  @override
  String toString() {
    // TODO: implement toString
    return "LoadStates(refresh=$refresh, prepend=$prepend, append=$append, " +
        "source=null, mediator=null)";
  }

  LoadStates modifyState(LoadType type, LoadState newState) {
    switch(type) {
      case LoadType.REFRESH:{
        return LoadStates(newState, append, prepend);
      }
      case LoadType.APPEND:
        return LoadStates(refresh, newState, prepend);
      case LoadType.PREPEND:
        return LoadStates(refresh, append, newState);
    }
  }

  factory LoadStates.idle() => LoadStates(
      NotLoading(false),
      NotLoading(false),
      NotLoading(false)
  );
}