import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final MethodChannel _cameraChannel = const MethodChannel('moniepoint.flutter.dev/liveliness');
final EventChannel _motionDetector = const EventChannel('moniepoint.flutter.dev/liveliness/events');

class LiveDetectorValue {
  const LiveDetectorValue();
  const LiveDetectorValue.uninitialized(): this();
}

abstract class LivelinessDetectorCallback {
  Future<void> pauseDetection();
  Future<void> resumeDetection();
}

class LivelinessDetector extends ValueNotifier<LiveDetectorValue> implements LivelinessDetectorCallback {

  LivelinessDetector() : super(LiveDetectorValue.uninitialized());

  int? _cameraId;

  Future<void> initialize() async {
    final result = await _cameraChannel.invokeMethod("create");
    final resultMap = result as Map<dynamic, dynamic>;
    _cameraId = resultMap["cameraId"];
    await _cameraChannel.invokeMethod("start");
  }

  Widget buildPreview() {
    return Texture(textureId: _cameraId!);
  }

  @override
  Future<void> pauseDetection() async {
    await _cameraChannel.invokeMethod("pause");
  }

  @override
  Future<void> resumeDetection() async {
    await _cameraChannel.invokeMethod("resume");
  }

  void _stopSession() async {
    await _cameraChannel.invokeMethod("close");
  }

  @override
  void dispose() {
    _stopSession();
    super.dispose();
  }
}