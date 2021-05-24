typedef LazyFunction<T> = T Function();

class Lazy<T> {

  Lazy(this._factory);

  final LazyFunction<T> _factory;

  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;

  T get value => (_isInitialized) ? _value : _initializeValue();
  late T _value;

  T _initializeValue() {
    _value = _factory();
    //_factory = null;
    _isInitialized = true;
    return _value;
  }

}

Lazy<T> lazy<T>(LazyFunction<T> a) {
  return Lazy<T>(a);
}