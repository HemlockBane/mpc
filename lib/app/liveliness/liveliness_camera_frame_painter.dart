
import 'package:flutter/material.dart';

class LivelinessCameraFramePainter extends CustomPainter {

  final Color borderColor;

  LivelinessCameraFramePainter(this.borderColor);

  late final _strokePaint = Paint()
    ..color = borderColor
    ..strokeWidth = 5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {

    var path = Path();

    var frameRect = Rect.fromCenter(center: Offset(size.width / 2, 280), width: 300, height: 380);

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
  bool shouldRepaint(covariant LivelinessCameraFramePainter oldDelegate) {
    return oldDelegate.borderColor != this.borderColor;
  }

}