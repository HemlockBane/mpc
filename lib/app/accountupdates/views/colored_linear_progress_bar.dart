import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class ColoredLinearProgressBar extends CustomPainter {
  double progress;
  final List<Tier> tiers;
  final double Function(Tier tier, double width) tierPositionCallback;
  final List<double> _tickerPoints = [];
  final ui.Image? checkMarkIcon;
  final double verticalProgressiveSpace;

  ColoredLinearProgressBar({
    this.repaint,
    required this.progress,
    this.tiers = const [],
    required this.tierPositionCallback,
    this.checkMarkIcon,
    this.verticalProgressiveSpace = 16
  }):super(repaint: repaint);

  late final double _strokeWidth = 8;

  final ValueNotifier<double>? repaint;


  final double _tickerStrokeWidth = 1;
  final double _tickerHeight = 24;

  double _startPadding = 0;
  double _endPadding = 0;
  Size? _size;
  final _checkIconMargin = 20;
  final _descriptionMarginTop = 3;

  bool _isBuilt = false;

  late final Paint _backgroundLinePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..color = Colors.grey.withOpacity(0.3)
    ..strokeWidth = _strokeWidth
    ..strokeCap = StrokeCap.round;

  late final Paint _progressPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..color = Colors.solidOrange.withOpacity(1)
    ..strokeWidth = _strokeWidth
    ..strokeCap = StrokeCap.round;


  final mPath = Path();
  ui.PathMetric? mPathMeasure;
  double mPathLength = 0;

  late final TextStyle _tickerTextStyle = TextStyle(
    color: Color(0XFF1A0C2F),
    fontSize: 13,
    fontFamily: Styles.defaultFont
  );

  late final TextStyle _tickerTextInactiveStyle = TextStyle(
      color: Color(0XFF1A0C2F).withOpacity(0.6),
      fontSize: 13,
      fontFamily: Styles.defaultFont
  );

  late final TextPainter _tickerTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  late final TextPainter _completedTextPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
  );

  late final _progressTextStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: Styles.defaultFont
  );

  late final Paint _tickerPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..color = Colors.grey.withOpacity(0.2)
    ..strokeWidth = _tickerStrokeWidth
    ..strokeCap = StrokeCap.butt;

  Color getCurrentProgressColor(double progress) {
    if(_tickerPoints.isEmpty) return Color(0XFFE94444);
    final percentageValues = _tickerPoints.map((e) => (e / (_size?.width ?? 0)) * 100);
    final centerIndex = (percentageValues.length ~/ 2).toInt().floor();
    final centerPercentageValue = percentageValues.elementAt(centerIndex);

    if (progress <= centerPercentageValue - 20) return Color(0XFFE94444);
    else if (progress >= centerPercentageValue - 20 && progress < centerPercentageValue) return Color(0XFFF08922);
    else if (progress >= centerPercentageValue) return Color(0XFF1EB12D);
    else return Color(0XFFE94444);
  }

  void _calculateTickerPoints(Size size) {
    _tickerPoints.clear();
    tiers.forEachIndexed((index, element) {
      if(index == 0) _tickerPoints.add(_startPadding - _tickerStrokeWidth);
      else if(index == (tiers.length - 1)) _tickerPoints.add((size.width + _tickerStrokeWidth) - _endPadding);
      else _tickerPoints.add(tierPositionCallback.call(element, size.width - _startPadding));
    });
  }

  void setProgress(double progress) {
    this.progress = progress;
  }

  bool isTickerActive(int index) {
    final percentageValues = _tickerPoints.map((e) => (e/_size!.width) * 100);
    return progress.toInt() >= percentageValues.elementAt(index);
  }

  void _drawTickers(Canvas canvas) {
    _tickerPoints.forEachIndexed((index, posX) {
      final tier = tiers[index];

      var startY = (_completedTextPainter.height - _backgroundLinePaint.strokeWidth / 2) + verticalProgressiveSpace;
      var textStartX = posX;
      var mTicketHeight = _tickerHeight;

      final tickerIsActive = isTickerActive(index);
      final checkedIconWidth = checkMarkIcon?.width ?? 0;

      if (index == 0 || index == _tickerPoints.length - 1) {
        startY = startY + _backgroundLinePaint.strokeWidth / 2;
        mTicketHeight = _tickerHeight - _backgroundLinePaint.strokeWidth / 2;
      }

      //For the last ticker, If the last ticker is active we simply need to create space
      //to draw the checked mark, we can simply subtract the width of the bitmap from the
      //original position to draw the text and subtract the endPadding as well
      if (index == _tickerPoints.length - 1 && !tickerIsActive) textStartX -= _tickerStrokeWidth;
      else if(index == _tickerPoints.length - 1 && tickerIsActive) textStartX -= (_tickerStrokeWidth + checkedIconWidth/2 + _checkIconMargin);

      canvas.drawLine(Offset(posX, startY), Offset(posX, startY + mTicketHeight), _tickerPaint);
      _tickerTextPainter
        ..text = TextSpan(text: _replaceName(tier.name), style: tickerIsActive ? _tickerTextStyle : _tickerTextInactiveStyle)
        ..layout(minWidth: 0, maxWidth: double.infinity)
        ..paint(
            canvas,
            Offset((textStartX - (_tickerTextPainter.width / 2)), startY + mTicketHeight + _descriptionMarginTop)
        );
      drawCheckedIconAtIndex(index, canvas, textStartX, startY + mTicketHeight);
    });
  }

  void drawCheckedIconAtIndex(int index, Canvas canvas, double startX, double startY) {
    if(isTickerActive(index) && checkMarkIcon != null) {
      final bitmap = checkMarkIcon;
      canvas.drawImage(bitmap!, Offset(startX + _checkIconMargin, (startY - (_descriptionMarginTop/2)) + bitmap.height/2), Paint());
    }
  }
  
  String _replaceName(String? name) {
    return name?.replaceAll("Moniepoint Customers ", "") ?? "";
  }

  void _setStartAndEndTextPadding() {
    if (tiers.isNotEmpty) {
      _startPadding = _textSize(_replaceName(tiers.first.name), _tickerTextStyle).width/2;
      _endPadding = _textSize(_replaceName(tiers.last.name), _tickerTextStyle).width/2;
    }
  }

  void createProgressiveLine() {
    mPath.reset();
    final radius = _backgroundLinePaint.strokeWidth / 2;
    final startX = _startPadding + radius - _tickerStrokeWidth * 2;
    final stopX = ((_size!.width - _endPadding) - radius) + _tickerStrokeWidth * 2;
    final startY = _completedTextPainter.height + verticalProgressiveSpace;

    mPath.moveTo(startX, startY);

    mPath.lineTo(stopX, startY);
    mPathMeasure = mPath.computeMetrics(forceClosed: false).first;
    mPathLength = mPathMeasure?.length ?? 0;
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  void _drawProgressText(Canvas canvas, Size size, Color progressColor) {
    _completedTextPainter
      ..text = TextSpan(
        children: [
          TextSpan(text: "Upgrade Completion: ", style: _progressTextStyle.copyWith(color: Colors.textColorBlack)),
          TextSpan(text: "${progress.toInt()}%", style: _progressTextStyle.copyWith(color: progressColor)),
        ],
      )
      ..layout(minWidth: 0, maxWidth: double.infinity)
      ..paint(canvas, Offset((size.width/2) - _completedTextPainter.width/2, 0));
  }

  @override
  void paint(Canvas canvas, Size size) {
    progress = repaint?.value ?? progress;

    this._size = size;

    if(!_isBuilt) _drawProgressText(canvas, size, Colors.transparent);

    if (_tickerPoints.isEmpty && tiers.isNotEmpty) {
      _setStartAndEndTextPadding();
      _calculateTickerPoints(size);
      createProgressiveLine();
    }

    final radius = _backgroundLinePaint.strokeWidth / 2;
    final startX = _startPadding + radius - _tickerStrokeWidth * 2;
    final stopX = ((size.width - _endPadding) - radius) + _tickerStrokeWidth * 2;

    final startY = _completedTextPainter.height + verticalProgressiveSpace;

    canvas.drawLine(Offset(startX, startY), Offset(stopX, startY), _backgroundLinePaint);

    final stopD = progress / 100 * mPathLength;

    final mDrawingPath = mPathMeasure?.extractPath(0, stopD, startWithMoveTo: true);
    if(mDrawingPath != null) {
      _progressPaint.color =  getCurrentProgressColor(progress);
      canvas.drawPath(mDrawingPath, _progressPaint);
      _drawProgressText(canvas, size, _progressPaint.color);
    }
    _drawTickers(canvas);
    _isBuilt = true;
  }

  @override
  bool shouldRepaint(covariant ColoredLinearProgressBar oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
