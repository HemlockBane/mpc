
import 'package:moniepoint_flutter/app/liveliness/liveliness_detector.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class LivelinessDetectionViewModel extends BaseViewModel {

  LivelinessMotionEvent? _firstCaptureEvent;
  LivelinessMotionEvent? get firstCaptureEvent => _firstCaptureEvent;

  LivelinessMotionEvent? _motionDetectedEvent;
  LivelinessMotionEvent? get motionDetectedEvent => _motionDetectedEvent;

  CameraMotionEvent? _previousMotionEvent;
  CameraMotionEvent? get previousMotionEvent => _previousMotionEvent;

  void setFirstCaptureEvent(LivelinessMotionEvent? firstCaptureEvent) {
    this._firstCaptureEvent = firstCaptureEvent;
  }

  void setMotionDetectedEvent(LivelinessMotionEvent? motionDetectedEvent) {
    this._motionDetectedEvent = motionDetectedEvent;
  }

  void setPreviousMotionEvent(CameraMotionEvent previousMotion) {
    this._previousMotionEvent = previousMotion;
  }

}