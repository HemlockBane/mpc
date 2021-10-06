import 'dart:async';

///@author Paul Okeke
abstract class InMemoryCache<T> {

  final List<T> _cache = List.of([]);
  final StreamController<List<T>> _controller = StreamController.broadcast();
  Stream<List<T>> get _stream => _controller.stream;

  InMemoryCache();

  Stream<List<T>> getItems() async* {
    yield _cache;
    yield* _stream;
  }

  List<T> getAllItems() {
    return List.from(_cache);
  }

  void add(T item) {
    _cache.add(item);
    _controller.sink.add(List.from(_cache));
  }

  void addAll(List<T> items) {
    _cache.addAll(items);
    _controller.sink.add(List.from(_cache));
  }

  void deleteAll() {
    _cache.clear();
    _controller.sink.add(List.from(_cache));
  }

  void close() {
    _controller.close();
  }
}