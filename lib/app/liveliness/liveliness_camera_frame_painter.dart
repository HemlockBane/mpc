
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/liveliness/liveliness_detector.dart';
import 'package:moniepoint_flutter/core/colors.dart';

const _left = 45.0;
const _top = 60.0;
const aspectRatio = 4/3.15;

class LivelinessFaceOval extends CustomPainter {

  LivelinessFaceOval();

  late final _backgroundPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..blendMode = BlendMode.srcOver;


  @override
  void paint(Canvas canvas, Size size) {
    var margin = 8.0;
    var frameRect = Rect.fromLTRB(_left + margin, _top+margin, (size.width - _left) - margin, (size.width *  aspectRatio) - margin);
    canvas.drawRRect(RRect.fromRectAndRadius(frameRect, Radius.circular(6)), _backgroundPaint);
  }
  @override
  bool shouldRepaint(covariant LivelinessFaceOval oldDelegate) {
    return true;
  }

}

class LivelinessCameraFrame extends CustomPainter {

  final ValueNotifier<LivelinessMotionEvent>? _valueNotifier;
  late Color borderColor = Colors.grey.withOpacity(0.1);
  var _previousEventColor = Colors.grey.withOpacity(0.1);

  LivelinessCameraFrame(this._valueNotifier): super(repaint: _valueNotifier) {
      borderColor = _getFrameColor(_valueNotifier?.value ?? LivelinessMotionEvent.none());
  }

  Color _getFrameColor(LivelinessMotionEvent liveMotionEvent) {
    if(liveMotionEvent.eventType == CameraMotionEvent.NoFaceDetectedEvent
    || liveMotionEvent.eventType == CameraMotionEvent.FaceOutOfBoundsEvent) {
      _previousEventColor = Colors.red;
    }

    if(liveMotionEvent.eventType == CameraMotionEvent.FaceDetectedEvent
        || liveMotionEvent.eventType == CameraMotionEvent.NoMotionDetectedEvent
        || liveMotionEvent.eventType == CameraMotionEvent.MotionDetectedEvent
        || liveMotionEvent.eventType == CameraMotionEvent.ImageUnderExposed
        || liveMotionEvent.eventType == CameraMotionEvent.FaceTooFarEvent
        || liveMotionEvent.eventType == CameraMotionEvent.ImageOverExposed ) {
      _previousEventColor = Colors.solidGreen;
    }

    return _previousEventColor;
  }

  late final _strokePaint = Paint()
    ..color = borderColor
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..blendMode = BlendMode.srcOver
    ..strokeCap = StrokeCap.round;

  var _faceRect = Rect.fromLTRB(0, 0, 0, 0);
  var _frameRect = Rect.fromLTRB(0, 0, 0, 0);

  final _faceRectPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 1.3;

  late final _backgroundPaint = Paint()
    ..color = Colors.white.withOpacity(0.25)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.5
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size   size) {

    borderColor = _getFrameColor(_valueNotifier?.value ?? LivelinessMotionEvent.none());
    _strokePaint.color = borderColor;

    var path = Path();

    _frameRect = Rect.fromLTRB(_left, _top, (size.width - _left), (size.width * aspectRatio));

    print("ScreenWidth => ${size.width}, ScreenHeight => ${size.height}");
    print("ImageWidth => ${_frameRect.width}, ImageHeight => ${_frameRect.height}");

    final lineDistanceToCurve = 16;

    path.moveTo(_frameRect.right - lineDistanceToCurve, _frameRect.top);
    path.quadraticBezierTo(_frameRect.right, _frameRect.top, _frameRect.right - 2, _frameRect.top  + lineDistanceToCurve);

    path.moveTo(_frameRect.right, _frameRect.bottom - lineDistanceToCurve);
    path.quadraticBezierTo(_frameRect.right, _frameRect.bottom, _frameRect.right - lineDistanceToCurve, _frameRect.bottom - 2);

    path.moveTo(_frameRect.left + lineDistanceToCurve, _frameRect.bottom);
    path.quadraticBezierTo(_frameRect.left, _frameRect.bottom, _frameRect.left + 2, _frameRect.bottom - lineDistanceToCurve);

    path.moveTo(_frameRect.left, _frameRect.top + lineDistanceToCurve);
    path.quadraticBezierTo(_frameRect.left, _frameRect.top, _frameRect.left + lineDistanceToCurve, _frameRect.top + 2);
    
    var frameRect = Rect.fromLTRB(_left + 8.0, _top + 8.0,
        (size.width - _left) - 8.0, (size.width * aspectRatio) - 8.0
    );
    canvas.drawRRect(RRect.fromRectAndRadius(frameRect, Radius.circular(6)), _backgroundPaint);

    canvas.drawPath(path, _strokePaint);
    _faceRect = _getFaceRect(size);
    canvas.drawRect(_faceRect, _faceRectPaint);
  }

  Rect _getFaceRect(Size size) {
    if(_valueNotifier?.value.eventType == CameraMotionEvent.DetectedFaceRectEvent) {
      final faceDetected = _valueNotifier?.value.eventData as String;
      final points = faceDetected.split(",");
      final mScale = size.width / 480;

      final faceRect = Rect.fromLTRB(
          double.parse(points[0]) * mScale,
          double.parse(points[1]) * mScale,
          double.parse(points[2]) * mScale,
          double.parse(points[3]) * mScale
      );

      if(faceRect.left < _frameRect.left
          || faceRect.top < _frameRect.top
          || faceRect.right > _frameRect.right
          || faceRect.bottom > _frameRect.bottom) {
        _faceRectPaint.color = Colors.red;
      } else {
        _faceRectPaint.color = Colors.solidGreen;
      }

      return faceRect;
    } else if(_valueNotifier?.value.eventType == CameraMotionEvent.NoFaceDetectedEvent) {
      return Rect.fromLTRB(0, 0, 0, 0);
    }
    return _faceRect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}