import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:rxdart/transformers.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_background_frame.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';

import 'liveliness_detector.dart';
import 'liveliness_exposure_range.dart';
import 'model/data/liveliness_verification_for.dart';
import 'model/strategy/liveliness_validation_strategy.dart';

/// @author Paul Okeke
class LivelinessDetectionGuide extends StatefulWidget {

  final Stream<LivelinessMotionEvent> motionEventStream;
  final LivelinessDetectorCallback callback;
  final LivelinessVerificationFor verificationFor;
  final dynamic arguments;

  LivelinessDetectionGuide({
    required this.motionEventStream,
    required this.callback,
    required this.verificationFor,
    this.arguments
  });

  @override
  State<StatefulWidget> createState() => _LivelinessDetectionGuide();

}

enum LivelinessState {
  LOCAL_ERROR,
  REMOTE_ERROR,
  PROCESSING,
  RUNNING,
}

class _LivelinessDetectionGuide extends State<LivelinessDetectionGuide> with TickerProviderStateMixin {

  late final AnimationController _controller;
  late final AnimationController _eventAnimationController = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _infoAnimation = CurvedAnimation(
    parent: _eventAnimationController,
    curve: Curves.easeIn,
  );

  LivelinessMotionEvent? _firstCaptureEvent;
  LivelinessMotionEvent? _motionDetectedEvent;
  CameraMotionEvent? _previousMotionEvent;
  late final ValueNotifier<LivelinessMotionEvent> _livelinessEventNotifier;

  Timer? _eventTimer;

  String _previousRemoteError = "";
  LivelinessState _state = LivelinessState.RUNNING;

  final livelinessEventToInfoSubject = {
    CameraMotionEvent.NoFaceDetectedEvent : Tuple(
        "No Face Detected",
        "Ensure you’re facing the camera.\nPosition head in frame to begin capture"
    ),
    CameraMotionEvent.NoMotionDetectedEvent : Tuple(
        "Nod your head",
        ""
    ),
    CameraMotionEvent.FaceOutOfBoundsEvent : Tuple(
        "Position your face in frame",
        ""
    ),
    CameraMotionEvent.ImageUnderExposed : Tuple(
        "Move to a brighter place",
        ""
    ),
    CameraMotionEvent.ImageOverExposed : Tuple(
        "Move to a darker place",
        ""
    ),
    CameraMotionEvent.FaceTooFarEvent : Tuple(
        "Move phone closer to your face",
        ""
    ),
    CameraMotionEvent.FaceTooCloseEvent : Tuple(
        "Face Too Close",
        "Ensure you are not too close to the camera"
    ),
    CameraMotionEvent.FaceNotCenteredEvent : Tuple(
        "Face Not Centered",
        "Ensure that your face is centered within the frame"
    )
  };

  void _processEvents(LivelinessMotionEvent motionEvent)  {
    //Discard DetectedFaceRectEvent, we only need it to track the face
    if(_motionDetectedEvent != null
        || motionEvent.eventType == CameraMotionEvent.DetectedFaceRectEvent
        || _state == LivelinessState.REMOTE_ERROR) return;

    if(_previousMotionEvent == motionEvent.eventType && _eventTimer?.isActive == true) {
      return;
    }

    if(_previousMotionEvent != motionEvent.eventType && _eventTimer?.isActive == true) {
      /*
       * since face-detected event is always emitted when a no-motion-event is emitted
       * we can skip restarting the timer so that we can report the no-motion-detected error/info
       * after an elapsed time
       */
      if(_previousMotionEvent == CameraMotionEvent.NoMotionDetectedEvent
          && motionEvent.eventType == CameraMotionEvent.FaceDetectedEvent) {
        return;
      }
      _state = LivelinessState.RUNNING;
      _eventAnimationController.reverse().whenComplete(() {
        _eventAnimationController.forward(from: 0.5);
      });
      _previousMotionEvent = motionEvent.eventType;
      _eventTimer?.cancel();
      _startTimer();
    }
    else if(_previousMotionEvent == null || _eventTimer?.isActive == false) {
      _previousMotionEvent = motionEvent.eventType;
      _eventTimer?.cancel();
      _startTimer();
    }

    if(motionEvent.eventType == CameraMotionEvent.FirstCaptureEvent) {
      _firstCaptureEvent = motionEvent;
    }
    if(motionEvent.eventType == CameraMotionEvent.MotionDetectedEvent) {
      _motionDetectedEvent = motionEvent;
      _eventTimer?.cancel();
      _validateLiveliness();
    }
  }

  void _restartCapture() async {
    _firstCaptureEvent = null;
    _motionDetectedEvent = null;
    _previousMotionEvent = null;
    _state = LivelinessState.RUNNING;
    _eventTimer?.cancel();
    await widget.callback.restart();
    await widget.callback.beginCapture();
  }

  void _validateLiveliness() async {
    final viewModel = Provider.of<LivelinessVerificationViewModel>(context, listen: false);
    final validationStrategy = LivelinessValidationStrategy.getInstance(
        viewModel, widget.verificationFor, widget.arguments
    );

    try {
      _state = LivelinessState.PROCESSING;

      final response = await validationStrategy.validate(
          _firstCaptureEvent?.eventData as String,
          _motionDetectedEvent?.eventData as String
      );
      if (response != null) {
        final isValid = _isLivelinessValid(response.livelinessError, response.faceMatchError);
        //Send back the response for the caller to handle
        if(isValid) return Navigator.of(context).pop(response);
      } else {
        Navigator.of(context).pop(response);
      }
    } catch(e) {
      FirebaseCrashlytics.instance.recordError(e, null);
      _state = LivelinessState.REMOTE_ERROR;
      var errorMessage = e.toString().replaceAll("Exception: ", "");
      if(mounted) _showGenericError(errorMessage);
    }
  }

  bool _isLivelinessValid(LivelinessError? livelinessError, ClientError? faceMatchError) {
    if(livelinessError != null && livelinessError.errors?.isNotEmpty == true) {
      final errors = livelinessError.errors ?? [];
      final error = errors.first;
      _state = LivelinessState.REMOTE_ERROR;
      widget.callback.endCapture();
      widget.callback.resumeDetection();
      _previousRemoteError = "${error.code}";
      return false;
    } else if(faceMatchError != null && faceMatchError.message?.isNotEmpty == true) {
      _showGenericError(faceMatchError.message, title: "Face Match Failed");
      return false;
    } 
    return true;
  }

  void _showGenericError(String? message, {String title = "Oops! Something went wrong"}) async {
    final value = await showError(
        context,
        message: message,
        title: title,
        primaryButtonText: "Try Again",
        onPrimaryClick: (){
          Navigator.of(context).pop(true);
          _restartCapture();
        }
    );
    if(value == null) {
      _restartCapture();
    }
  }

  void _startTimer() {
    _eventTimer = Timer.periodic(Duration(seconds: 1), (timer)  {
      _eventTimer?.cancel();
      if(_previousMotionEvent == CameraMotionEvent.FaceDetectedEvent) return;
      _state = LivelinessState.LOCAL_ERROR;
      Future.delayed(Duration(milliseconds: 200), () {
        if(mounted) _eventAnimationController.forward();
      });
    });
  }

  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _livelinessEventNotifier = ValueNotifier(LivelinessMotionEvent.none());
    _eventAnimationController.forward();

    //To Ensure that we don't miss this events from the streamBuilder
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.motionEventStream.listen((event) {
        if(event.eventType == CameraMotionEvent.FirstCaptureEvent
            && _firstCaptureEvent == null) {
          _firstCaptureEvent = event;
        }
      });
    });
  }

  void _tryAgain() {
    if(_state == LivelinessState.REMOTE_ERROR) {
      return _restartCapture();
    }
    _state = LivelinessState.RUNNING;
    widget.callback.resumeDetection();
  }

  Widget _getInfoIconForState() {
    if(_state == LivelinessState.RUNNING) {
      return Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.solidOrange
        ),
        child: SvgPicture.asset('res/drawables/ic_face.svg', width: 30, height: 30, color: Colors.white,),
      );
    }
    if(_state == LivelinessState.PROCESSING) {
      return Lottie.asset('res/drawables/progress_bar_lottie.json', width: 48, height: 48);
    }

    if(_state == LivelinessState.REMOTE_ERROR) {
      return SvgPicture.asset('res/drawables/ic_info.svg', width: 30, height: 30, color: Colors.red,);
    }

    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.solidOrange
      ),
      child: SvgPicture.asset('res/drawables/ic_face.svg', width: 30, height: 30, color: Colors.white,),
    );
  }

  String _getInfoTitleForState(Tuple<String, String>? info) {
    if(_state == LivelinessState.RUNNING) {
      return "Analyzing Face";
    }
    if(_state == LivelinessState.PROCESSING) {
      return "";
    }
    if(_state == LivelinessState.REMOTE_ERROR) {
      return _previousRemoteError;
    }

    return info?.first ?? "";
  }

  String _getInfoMessageForState(Tuple<String, String>? info) {
    if(_state == LivelinessState.RUNNING) {
      return "Please Position your face within the frame.";
    }
    if(_state == LivelinessState.PROCESSING) {
      return "Processing, please wait";
    }
    if(_state == LivelinessState.REMOTE_ERROR) return "";

    return info?.second ?? "";
  }

  StreamBuilder<LivelinessMotionEvent> _bottomSection() {
    final screenSize = MediaQuery.of(context).size;
    final itemSize = screenSize.height - (screenSize.height * 0.67);

    return StreamBuilder(
        stream: widget.motionEventStream.delay(Duration(milliseconds: 100)),
        builder: (context, AsyncSnapshot<LivelinessMotionEvent> motionEvent) {

          final LivelinessMotionEvent liveMotionEvent = (motionEvent.hasData)
              ? motionEvent.data ?? LivelinessMotionEvent.none()
              : LivelinessMotionEvent.none();

          print("CameraMotionEvent => ${liveMotionEvent.eventType}");
          _processEvents(liveMotionEvent);

          Future.delayed(Duration(milliseconds: 1), () {
            _livelinessEventNotifier.value = liveMotionEvent;
          });

          final infoForState = (_state == LivelinessState.RUNNING)
              ? null
              : livelinessEventToInfoSubject[_previousMotionEvent];

          String infoTitle = _getInfoTitleForState(infoForState);
          String infoMessage = _getInfoMessageForState(infoForState);
          Widget infoIcon = _getInfoIconForState();

          return Container(
            width: double.infinity,
            height: max(250, itemSize),
            padding: EdgeInsets.only(top: 24),
            child: Column(
              children: [
                Center(child: infoIcon),
                SizedBox(height: 12),
                FadeTransition(
                  opacity: _infoAnimation,
                  child: Text(infoTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: 8),
                Flexible(
                    fit: FlexFit.loose,
                    child: Text(infoMessage, textAlign: TextAlign.center)
                ),
                SizedBox(height: _state == LivelinessState.REMOTE_ERROR ? 24 : 0),
                Visibility(
                  visible: _state == LivelinessState.REMOTE_ERROR,
                  child: Flexible(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Divider(color: Colors.grey.withOpacity(0.1), height: 1,),
                      )
                  ),
                ),
                Visibility(
                    visible: _state == LivelinessState.REMOTE_ERROR,
                    child: Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: TextButton(
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                  color: Colors.primaryColor,
                                  fontSize: 16)
                              ),
                            onPressed: () => _tryAgain(),
                          ),
                        )
                    )
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final sheetSize = 1 - 0.67;
    final exposureWidth = screenSize.width * 0.85;

    return Container(
      height: screenSize.height,
      child: Stack(
        children: [
          LivelinessBackgroundFrame(_livelinessEventNotifier),
          LivelinessExposureRange(_livelinessEventNotifier, 90, 220, exposureWidth, 36),
          DraggableScrollableSheet(
            initialChildSize: sheetSize,
            minChildSize: sheetSize,
            maxChildSize: sheetSize + 0.1,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    ),
                    color: Colors.white
                ),
                child: ListView.builder(
                    controller: scrollController,
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (BuildContext ctx, int index) {
                      return _bottomSection();
                    }
                ),
              );
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.callback.restart();
    _controller.dispose();
    _eventAnimationController.dispose();
    _eventTimer?.cancel();
    super.dispose();
  }

}