import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_exposure_range_boundary.dart';
import 'package:moniepoint_flutter/core/colors.dart';

import 'liveliness_detector.dart';

class LivelinessExposureRange extends StatefulWidget {

  final double start;
  final double end;
  final double width;
  final double height;
  final ValueNotifier<LivelinessMotionEvent> notifier;

  LivelinessExposureRange(
      this.notifier,
      this.start,
      this.end,
      this.width,
      this.height
  );

  @override
  State<StatefulWidget> createState() => _LivelinessExposureRange();
}

class _LivelinessExposureRange extends State<LivelinessExposureRange> {

  final double _linearMargin = 44;
  final double _maxColorValue = 255;
  var _previousTickerPosition = 0.0;

  double _getTickerPosition(LivelinessMotionEvent motionEvent, double scaleFactor) {
    var position = _previousTickerPosition;
    if(motionEvent.eventType == CameraMotionEvent.ImageUnderExposed
        || motionEvent.eventType == CameraMotionEvent.ImageOverExposed) {
      final exposure = motionEvent.eventData as double;
      _previousTickerPosition = exposure * scaleFactor;
      return _previousTickerPosition;
    } else if(motionEvent.eventType == CameraMotionEvent.FaceDetectedEvent && motionEvent.exposure != null){
      final exposure = motionEvent.exposure!;
      _previousTickerPosition = exposure * scaleFactor;
      return _previousTickerPosition;
    }
    return position;
  }

  bool _positionIsWithinRange(double position, double scaleFactor) {
    final start = (widget.start * scaleFactor);
    final end = widget.end * scaleFactor;
    return position >= (start) && position <= end;
  }

  @override
  Widget build(BuildContext context) {
    final widthOfCenterLine = widget.width - (_linearMargin * 2);
    final colorRangeScale = widthOfCenterLine / _maxColorValue;

    //scale the color range values to this
    final startPoint = widget.start * colorRangeScale;
    final endPoint = widget.end * colorRangeScale;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.23),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 16,
                child: SvgPicture.asset(
                  'res/drawables/ic_liveliness_darkness.svg',
                  color: Colors.white,
                  width: 20,
                  height: 20,
                )
            ),
            Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: SvgPicture.asset(
                  'res/drawables/ic_liveliness_brightness.svg',
                  color: Colors.white,
                  width: 20,
                  height: 20,
                )
            ),
            Positioned(
                left: _linearMargin,
                right: _linearMargin,
                top: (widget.height / 2) - 5,
                bottom: (widget.height / 2)  - 5,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13),
                      gradient: LinearGradient(colors: [
                        Color(0xFF000000),
                        Color(0xFFFFFFFF),
                      ])
                  ),
                )
            ),
            ValueListenableBuilder<LivelinessMotionEvent>(
                valueListenable: widget.notifier,
                builder: (context, LivelinessMotionEvent value, _) {
                  final position = _getTickerPosition(value, colorRangeScale);
                  final isWithinRange = _positionIsWithinRange(position, colorRangeScale);
                  return AnimatedPositionedDirectional(
                      child: Container(
                        height: widget.height,
                        width: 2,
                        color: isWithinRange ? Colors.solidGreen : Colors.red,
                      ),
                      start: _linearMargin + position,
                      duration: Duration(milliseconds: 209)
                  );
                }
            ),
            Positioned(
                left: _linearMargin + startPoint,
                child: ValueListenableBuilder(
                  valueListenable: widget.notifier,
                  builder: (context, LivelinessMotionEvent value, _) {
                    final position = _getTickerPosition(value, colorRangeScale);
                    final isWithinRange = _positionIsWithinRange(position, colorRangeScale);
                    return CustomPaint(
                      painter: LivelinessExposureRangeBoundary(
                          endPoint - startPoint,
                          widget.height,
                          isWithinRange ? Colors.solidGreen : Colors.red
                      ),
                    );
                  },
                )
            ),
          ],
        ),
      ),
    );
  }

}

//349