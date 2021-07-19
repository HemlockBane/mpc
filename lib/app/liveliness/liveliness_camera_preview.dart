import 'package:flutter/material.dart';

import 'liveliness_detector.dart';

class LivelinessCameraPreview extends StatelessWidget {

  final LivelinessDetector _livelinessDetector;

  LivelinessCameraPreview(this._livelinessDetector);

  @override

  Widget build(BuildContext context) {
    return _livelinessDetector.buildPreview();
  }

}