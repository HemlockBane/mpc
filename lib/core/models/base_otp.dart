
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// @author Paul Okeke
abstract class BaseOtp<I, O> {

  final bool autoStart;
  final int retryTime;
  final String key;

  final _responseController = StreamController<O>.broadcast();
  Stream<O> get responseStream => _responseController.stream;

  I data;

  BaseOtp({required this.key, required this.data, this.autoStart = true, this.retryTime = 1000}) {
    _shouldRequest().then((value) {
        if(autoStart && value) _send();
    });
  }

  void updateData(I data) {
    this.data = data;
  }

  Future<bool> _shouldRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final lastFetchTime = prefs.getInt(key) ?? 0;
    final lastFetchDateTime = DateTime.fromMillisecondsSinceEpoch(lastFetchTime);
    final currentTime = DateTime.now();
    final diff = currentTime.difference(lastFetchDateTime);
    if(diff.inMilliseconds > retryTime) return true;
    return false;
  }

  Stream<O> call();

  void _send() async {
    call().listen((event) {
      _responseController.add(event);
      _updateTime();
    });
  }

  void _updateTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, DateTime.now().millisecondsSinceEpoch);
  }

  void dispose() {
    _responseController.close();
  }

}