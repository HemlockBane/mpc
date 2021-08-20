import 'dart:async';

///@author Paul Okeke
class CompositeDisposableWidget {

  final List<StreamSubscription> _compositeDisposables = [];

  void disposeAll() {
    _compositeDisposables.forEach((element) => element.cancel());
  }

  void addDisposable(StreamSubscription subscription) {
    _compositeDisposables.add(subscription);
  }

}

extension CompositeDisposable on StreamSubscription {
  void disposedBy(CompositeDisposableWidget disposableWidget) {
    disposableWidget.addDisposable(this);
  }
}