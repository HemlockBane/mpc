
import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';


enum ResponseState {
  LOADING, SUCCESS, ERROR, IDLE
}
///
///@author Paul Okeke
///
abstract class ResponseObserver<T extends Resource<dynamic>> {

  ResponseObserver({
    required this.context,
    this.setState
  });

  final BuildContext context;
  final Function()? setState;

  final List<Function(ResponseState? state)> listeners = List.empty(growable: true);

  ResponseState _responseState = ResponseState.IDLE;
  ResponseState get responseState => _responseState;

  void updateResponseState(ResponseState responseState) {
    this._responseState = responseState;
    listeners.forEach((element) {
      element.call(responseState);
    });
  }

  void observe(T event);

  void addStateListener(Function(ResponseState? state) listener) {
    if(!this.listeners.contains(listener))
      this.listeners.add(listener);
  }

  void removeStateListener(Function(ResponseState? state) listener) {
    if(!this.listeners.contains(listener))
      this.listeners.remove(listener);
  }

}



