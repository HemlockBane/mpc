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

  LoadStates combineStates(LoadStates localState, LoadStates remoteState){
    LoadState aRefresh = LoadState(false);
    LoadState aAppend = LoadState(false);

    if(localState.refresh is Loading || remoteState.refresh is Loading) {
      aRefresh = Loading(endOfPaginationReached: remoteState.refresh.endOfPaginationReached);
    }
    if(localState.append is Loading || remoteState.refresh is Loading) {
      aAppend = Loading(endOfPaginationReached: remoteState.refresh.endOfPaginationReached);
    }
    if(localState.refresh is NotLoading || remoteState.refresh is NotLoading) {
      aAppend = NotLoading(remoteState.refresh.endOfPaginationReached);
    }
    return LoadStates(aRefresh, aAppend, prepend);
  }

  factory LoadStates.idle() => LoadStates(
      NotLoading(false),
      NotLoading(false),
      NotLoading(false)
  );
}