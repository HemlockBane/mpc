import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

final MethodChannel _cameraChannel = const MethodChannel('moniepoint.flutter.dev/liveliness');
final EventChannel _motionDetector = const EventChannel('moniepoint.flutter.dev/liveliness/events');

class LiveDetectorValue {
  const LiveDetectorValue();
  const LiveDetectorValue.uninitialized(): this();
}

abstract class LivelinessDetectorCallback {
  void startMotionDetection();
  Future<void> pauseDetection();
  Future<void> resumeDetection();
  Future<void> restart();
  Future<void> beginCapture();
  Future<void> endCapture();
}

enum CameraMotionEvent {
  FirstCaptureEvent,
  FaceDetectedEvent,
  NoFaceDetectedEvent,
  MotionDetectedEvent,
  NoMotionDetectedEvent,
  FaceOutOfBoundsEvent,
  ImageOverExposed,
  ImageUnderExposed,
  DetectedFaceRectEvent,
  FaceTooFarEvent,
  FaceTooCloseEvent,
  FaceNotCenteredEvent,
  UNKNOWN
}

class LivelinessMotionEvent {
  final CameraMotionEvent eventType;
  final dynamic eventData;
  final double? exposure;

  LivelinessMotionEvent({required this.eventType, this.eventData, this.exposure});

  const LivelinessMotionEvent.none({this.eventType = CameraMotionEvent.UNKNOWN, this.eventData, this.exposure});
}

class LivelinessDetector extends ValueNotifier<LiveDetectorValue> implements LivelinessDetectorCallback {

  LivelinessDetector() : super(LiveDetectorValue.uninitialized());

  StreamController<LivelinessMotionEvent> _motionEventEmitter = StreamController.broadcast();
  Stream<LivelinessMotionEvent> get motionEventStream => _motionEventEmitter.stream;

  int? _cameraId;

  Future<void> initialize({Rect? frameSize, Size? previewSize}) async {
    final arguments = {};

    if(frameSize != null) {
      arguments["frameSize"] = {
        "left": frameSize.left,
        "top": frameSize.top,
        "right": frameSize.right,
        "bottom": frameSize.bottom
      };
    }
    if(previewSize != null) {
      arguments["previewSize"] = {
        "width": previewSize.width,
        "height": previewSize.height,
      };
    }

    final result = await _cameraChannel.invokeMethod("create", arguments);
    final resultMap = result as Map<dynamic, dynamic>;
    _cameraId = resultMap["cameraId"];
    await _cameraChannel.invokeMethod("start", );
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

  @override
  Future<void> restart()  async{
    await _cameraChannel.invokeMethod("restart");
  }

  void _stopSession() async {
    await _cameraChannel.invokeMethod("close");
  }

  @override
  Future<void> beginCapture() async {
    await _cameraChannel.invokeMethod("begin_capture");
  }

  @override
  Future<void> endCapture() async {
    await _cameraChannel.invokeMethod("end_capture");
  }

  @override
  void startMotionDetection() {
    _motionDetector.receiveBroadcastStream().listen((event) {
      if(event is! Map) return;
      final cameraMotionEvent = eventFromString(event["event_type"]);
      final data = event["event_data"];
      final motionEvent = LivelinessMotionEvent(
          eventType: cameraMotionEvent, eventData: data, exposure: event["exposure"] ?? null
      );
      if(!_motionEventEmitter.isClosed) _motionEventEmitter.sink.add(motionEvent);
    }).onDone(() {
      print("Closing Live Detection Stream...");
      _motionEventEmitter.close();
    });
  }

  CameraMotionEvent eventFromString(String eventName) {
    final events = CameraMotionEvent.values.where((element) => describeEnum(element) == eventName);
    return (events.length > 0) ? events.first :  CameraMotionEvent.UNKNOWN;
  }

  @override
  void dispose() {
    _motionEventEmitter.close();
    _stopSession();
    super.dispose();
  }

}