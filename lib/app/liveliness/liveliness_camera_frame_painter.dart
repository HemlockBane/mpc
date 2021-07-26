
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/liveliness/liveliness_detector.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class LivelinessFaceOval extends CustomPainter {

  LivelinessFaceOval();

  late final _backgroundPaint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill
    ..blendMode = BlendMode.srcOver;

  @override
  void paint(Canvas canvas, Size size) {
    var frameRect = Rect.fromLTRB(55, 90, size.width - 55, size.height / 1.72);
    canvas.drawOval(frameRect, _backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant LivelinessFaceOval oldDelegate) {
    return true;
  }

}

class LivelinessCameraFrame extends CustomPainter {

  final ValueNotifier<LivelinessMotionEvent>? _valueNotifier;

  late Color borderColor = Colors.grey.withOpacity(0.1);

  LivelinessCameraFrame(this._valueNotifier): super(repaint: _valueNotifier) {
      borderColor = _getFrameColor(_valueNotifier?.value ?? LivelinessMotionEvent.none());
  }

  Color _getFrameColor(LivelinessMotionEvent liveMotionEvent) {
    if(liveMotionEvent.eventType == CameraMotionEvent.NoFaceDetectedEvent) {
      return Colors.red;
    }

    if(liveMotionEvent.eventType == CameraMotionEvent.FaceDetectedEvent
        || liveMotionEvent.eventType == CameraMotionEvent.NoMotionDetectedEvent
        || liveMotionEvent.eventType == CameraMotionEvent.MotionDetectedEvent) {
      return Colors.solidGreen;
    }

    if(liveMotionEvent.eventType == CameraMotionEvent.FaceOutOfBoundsEvent) {
      return Colors.solidDarkYellow;
    }

    return Colors.grey.withOpacity(0.1);
  }

  late final _strokePaint = Paint()
    ..color = borderColor
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..blendMode = BlendMode.srcOver
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {

    borderColor = _getFrameColor(_valueNotifier?.value ?? LivelinessMotionEvent.none());
    _strokePaint.color = borderColor;

    var path = Path();

    var frameRect = Rect.fromLTRB(55, 90, size.width - 55, size.height / 1.72);

    print("ScreenWidth => ${size.width}, ScreenHeight => ${size.height}");
    print("ImageWidth => ${frameRect.width}, ImageHeight => ${frameRect.height}");

    final lineDistanceToCurve = 16;

    path.moveTo(frameRect.right - lineDistanceToCurve, frameRect.top);
    path.quadraticBezierTo(frameRect.right, frameRect.top, frameRect.right - 2, frameRect.top  + lineDistanceToCurve);

    path.moveTo(frameRect.right, frameRect.bottom - lineDistanceToCurve);
    path.quadraticBezierTo(frameRect.right, frameRect.bottom, frameRect.right - lineDistanceToCurve, frameRect.bottom - 2);

    path.moveTo(frameRect.left + lineDistanceToCurve, frameRect.bottom);
    path.quadraticBezierTo(frameRect.left, frameRect.bottom, frameRect.left + 2, frameRect.bottom - lineDistanceToCurve);

    path.moveTo(frameRect.left, frameRect.top + lineDistanceToCurve);
    path.quadraticBezierTo(frameRect.left, frameRect.top, frameRect.left + lineDistanceToCurve, frameRect.top + 2);

    canvas.drawPath(path, _strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}