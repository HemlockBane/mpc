import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

/// @author Paul Okeke
class LivelinessExposureRangeBoundary extends CustomPainter {

  final double width;
  final double height;
  final Color color;

  LivelinessExposureRangeBoundary(this.width, this.height, this.color);

  final _sliderPaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  final _sliderBackgroundPaint = Paint()
    ..color = Colors.white.withOpacity(0.23)
    ..style = PaintingStyle.fill;

  final _path = Path();

  @override
  void paint(Canvas canvas, Size size) {

    _path.reset();

    final rect = Rect.fromLTWH(0, 0, width, height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(13));
    final lineDistanceToCurve = 16;
    
    _path.moveTo(rRect.right - lineDistanceToCurve, rRect.top);
    _path.quadraticBezierTo(rRect.right, rRect.top, rRect.right, rRect.top + 12);
    _path.lineTo(rRect.right, rect.bottom - 12);
    _path.quadraticBezierTo(
        rRect.right,
        rRect.bottom,
        rRect.right - lineDistanceToCurve,
        rRect.bottom
    );

    _path.moveTo(rRect.left + lineDistanceToCurve, rRect.bottom);
    _path.quadraticBezierTo(rRect.left, rRect.bottom, rRect.left, rRect.bottom - 12);
    _path.lineTo(rRect.left, rRect.top + 12);
    _path.quadraticBezierTo(
        rRect.left,
        rRect.top,
        rRect.left + lineDistanceToCurve,
        rRect.top
    );

    _sliderPaint.color = color;
    canvas.drawRRect(rRect, _sliderBackgroundPaint);
    canvas.drawPath(_path, _sliderPaint);
  }

  @override
  bool shouldRepaint( LivelinessExposureRangeBoundary oldDelegate) {
    return oldDelegate.width != width || oldDelegate.color != color;
  }

}