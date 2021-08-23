import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/liveliness/liveliness_detector.dart';
import 'package:moniepoint_flutter/core/colors.dart';

import 'liveliness_camera_frame_painter.dart';

class LivelinessBackgroundFrame extends StatelessWidget {

  final ValueNotifier<LivelinessMotionEvent> notifier;
  LivelinessBackgroundFrame(this.notifier);

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;
    final maxHeight = MediaQuery.of(context).size.height;

    return Container(
      width: maxWidth,
      height: maxHeight,
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Container(
                  width: maxWidth,
                  height: maxHeight,
                  child: CustomPaint(
                    painter: LivelinessFaceOval(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: maxWidth,
            height: maxHeight,
            child: CustomPaint(
              painter: LivelinessCameraFrame(notifier),
            ),
          ),
        ],
      ),
    );
  }


}