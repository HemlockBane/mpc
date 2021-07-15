import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/views/liveliness/liveliness_detector.dart';

class LivelinessCameraPreview extends StatelessWidget {

  final LivelinessDetector _livelinessDetector;

  LivelinessCameraPreview(this._livelinessDetector);

  @override

  Widget build(BuildContext context) {
    return _livelinessDetector.buildPreview();
  }

}