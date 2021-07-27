import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_error.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_background_frame.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

import 'liveliness_detector.dart';
import 'liveliness_verification.dart';
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
  STARTED,
  LOCAL_ERROR,
  REMOTE_ERROR,
  INFO,
  PROCESSING,
  RUNNING,
  PAUSED
}

class _LivelinessDetectionGuide extends State<LivelinessDetectionGuide> with TickerProviderStateMixin {

  late final AnimationController _controller;
  late final AnimationController _eventAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this,)..repeat(reverse: true);

  late final Animation<double> _motionInfoAnimation = CurvedAnimation(
    parent: _eventAnimationController,
    curve: Curves.easeIn,
  );

  LivelinessMotionEvent? _firstCaptureEvent;
  LivelinessMotionEvent? _motionDetectedEvent;
  CameraMotionEvent? _previousMotionEvent;
  ValueNotifier<LivelinessMotionEvent>? _livelinessEventNotifier;

  Timer? _eventTimer;

  String _previousRemoteError = "";
  LivelinessState _state = LivelinessState.STARTED;

  void _processEvents(LivelinessMotionEvent motionEvent) async {
    if(_motionDetectedEvent != null
        || _state == LivelinessState.LOCAL_ERROR
        || _state == LivelinessState.STARTED
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
      _eventAnimationController.reverse();
      _eventTimer?.cancel();
      _validateLiveliness();
    }
  }

  void _restartCapture() async {
    _firstCaptureEvent = null;
    _motionDetectedEvent = null;
    _previousMotionEvent = null;
    _state = LivelinessState.STARTED;
    _eventTimer?.cancel();
    await widget.callback.endCapture();
    await widget.callback.restart();
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
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      _state = LivelinessState.REMOTE_ERROR;
      _showGenericError(e.toString());
    }
  }

  bool _isLivelinessValid(LivelinessError? livelinessError, ClientError? faceMatchError) {
    if(livelinessError != null && livelinessError.errors?.isNotEmpty == true) {
      final errors = livelinessError.errors ?? [];
      final error = errors.first;
      widget.callback.endCapture();
      widget.callback.resumeDetection();
      _state = LivelinessState.REMOTE_ERROR;
      _previousRemoteError = "${error.code}";
      return false;
    } else if(faceMatchError != null && faceMatchError.message?.isNotEmpty == true) {
      _showGenericError(faceMatchError.message);
      return false;
    } 
    return true;
  }

  void _showGenericError(String? message) async {
    await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) {
          return BottomSheets.displayErrorModal(context, message: message, onClick: (){
            Navigator.of(context).pop();
            _restartCapture();
          }, buttonText: "Try Again");
        }
    );
    if(_state == LivelinessState.PROCESSING) {
      _restartCapture();
    }
  }

  void _startTimer() {
    _eventTimer = Timer.periodic(Duration(seconds: 5), (timer)  {
      _eventTimer?.cancel();
      if(_previousMotionEvent == CameraMotionEvent.NoFaceDetectedEvent) {
        _state = LivelinessState.LOCAL_ERROR;
        widget.callback.pauseDetection().then((value) => "");
      } else if (_previousMotionEvent == CameraMotionEvent.NoMotionDetectedEvent){
        if(timer.tick > 1) {
          _state = LivelinessState.LOCAL_ERROR;
        } else {
          _state = LivelinessState.INFO;
        }

        if(_state == LivelinessState.LOCAL_ERROR) {
          widget.callback.pauseDetection().then((value) => "");
        }
        if(_state == LivelinessState.INFO) {
          Future.delayed(Duration(milliseconds: 200), () => _eventAnimationController.forward());
        }
      } else if(_previousMotionEvent == CameraMotionEvent.ImageOverExposed
          || _previousMotionEvent == CameraMotionEvent.ImageUnderExposed) {
        _state = LivelinessState.LOCAL_ERROR;
        widget.callback.pauseDetection().then((value) => "");
      }
    });
  }

  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _livelinessEventNotifier = ValueNotifier(LivelinessMotionEvent.none());

  }

  String _getEventInfoMessage(LivelinessMotionEvent motionEvent) {
    if(motionEvent.eventType == CameraMotionEvent.NoFaceDetectedEvent) {
      return "Checking for face...";
    }
    if(motionEvent.eventType == CameraMotionEvent.FaceOutOfBoundsEvent && _state != LivelinessState.STARTED) {
      return "Position face in frame";
    }
    return "";
  }

  Widget _livelinessInfo(LivelinessMotionEvent motionEvent) {
    final infoMessage = _getEventInfoMessage(motionEvent);
    if(infoMessage.isEmpty) return SizedBox();
    return Container(
      padding: infoMessage.isEmpty ? EdgeInsets.all(8) : EdgeInsets.only(left: 8, top: 3, bottom: 3, right: 8),
      decoration: BoxDecoration(
          borderRadius: infoMessage.isEmpty ? null : BorderRadius.circular(120),
          color: Colors.white,
          shape: (infoMessage.isEmpty) ? BoxShape.circle : BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
                color: Colors.primaryColor.withOpacity(0.01),
                offset: Offset(0, -1),
                blurRadius: 3,
                spreadRadius: 0
            )
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
              visible: true,
              child: Lottie.asset('res/drawables/progress_bar_lottie.json', width: 36, height: 36)
          ),
          Visibility(visible: infoMessage.isNotEmpty, child: SizedBox(width: 8,)),
          Visibility(
              child: Flexible(child: Text(
                  infoMessage,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack
                  )
              ))
          )
        ],
      ),
    );
  }

  String _getErrorMessage() {
    if(_state == LivelinessState.REMOTE_ERROR) {
      return _previousRemoteError;
    }
    if(_previousMotionEvent == CameraMotionEvent.NoFaceDetectedEvent) {
      return "No Face Detected";
    }
    if(_previousMotionEvent == CameraMotionEvent.NoMotionDetectedEvent) {
        return "No Motion Detected";
    }
    if(_previousMotionEvent == CameraMotionEvent.ImageOverExposed) {
      return "Image is too bright";
    }
    if(_previousMotionEvent == CameraMotionEvent.ImageUnderExposed) {
      return "Image is too dark";
    }
    return "";
  }

  void _tryAgain() {
    if(_state == LivelinessState.REMOTE_ERROR) {
      return _restartCapture();
    }
    _state = LivelinessState.RUNNING;
    widget.callback.resumeDetection();
  }

  Widget _livelinessErrorInfo(LivelinessMotionEvent motionEvent) {
    return Container(
      padding: EdgeInsets.only(left: 8, top: 3, bottom: 3, right: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(120),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.primaryColor.withOpacity(0.01),
                offset: Offset(0, -1),
                blurRadius: 3,
                spreadRadius: 0
            )
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            width: 44,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red
            ),
            child: Center(
              child: SvgPicture.asset('res/drawables/ic_face.svg', width: 30, height: 30,),
            ),
          ),
          Visibility(visible: true, child: SizedBox(width: 15,)),
          Expanded(child: Text(
              _getErrorMessage(),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.textColorBlack
              )
          )),
          Flexible(
              child:TextButton(
                  onPressed: () => _tryAgain(),
                  child: Text('Try Again',
                      style: TextStyle(color: Colors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)
                  )
              )
          )
        ],
      ),
    );
  }

  Widget _motionInfoWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: 200,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.8)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("res/drawables/ic_info.svg", color: Colors.white,),
              SizedBox(height: 4),
              Flexible(child: Text(
                'Nod so we can capture\nyour face properly',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _beginLivelinessCapture() {
    _state = LivelinessState.RUNNING;
    widget.callback.resumeDetection();
    widget.callback.beginCapture();
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
              Stack(
                children: [
                  LivelinessBackgroundFrame(_livelinessEventNotifier!),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: (MediaQuery.of(context).size.height / 1.7 ) + 16,
                    child: StreamBuilder(
                        stream: widget.motionEventStream,
                        builder: (mContext, AsyncSnapshot<LivelinessMotionEvent> motionEvent) {

                          final liveMotionEvent = (motionEvent.hasData)
                              ? motionEvent.data ?? LivelinessMotionEvent.none()
                              : LivelinessMotionEvent.none();

                          _processEvents(liveMotionEvent);

                          _livelinessEventNotifier?.value = liveMotionEvent;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Visibility(
                                  visible: _state == LivelinessState.STARTED,
                                  child: Text(
                                    'Position your face within \nthe frame then begin capture',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16
                                    ),
                                  )
                              ),
                              Visibility(
                                  visible: _firstCaptureEvent != null && _state == LivelinessState.INFO,
                                  child: FadeTransition(
                                    opacity: _motionInfoAnimation,
                                    child: _motionInfoWidget(),
                                  )
                              ),
                              SizedBox(height: 100,),
                              Visibility(
                                  visible: _state == LivelinessState.STARTED,
                                  child: Opacity(//TODO change this opacity widget it's expensive here
                                      opacity: liveMotionEvent.eventType == CameraMotionEvent.FaceDetectedEvent ? 1 : 0.5,
                                      child: Styles.appButton(
                                          key: Key("capture-btn"),
                                          onClick: liveMotionEvent.eventType == CameraMotionEvent.FaceDetectedEvent ? () => _beginLivelinessCapture() : null,
                                          text:  "Begin Capture",
                                          icon: SvgPicture.asset('res/drawables/ic_face_match_camera.svg', color: Colors.primaryColor, width: 20, height: 20,),
                                          buttonStyle: Styles.whiteButtonStyle,
                                          textStyle: TextStyle(
                                              color: Colors.primaryColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: Styles.defaultFont
                                          ),
                                          borderRadius: 120,
                                          padding: null,
                                          paddingTop: 14,
                                          paddingBottom: 14,
                                          paddingStart: 12,
                                          paddingEnd: 12
                                      ),
                                  )
                              ),
                              Visibility(
                                  visible: _state == LivelinessState.RUNNING || _state == LivelinessState.INFO,
                                  child: _livelinessInfo(liveMotionEvent)
                              ),
                              Visibility(
                                  visible: _state == LivelinessState.PROCESSING,
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white
                                    ),
                                    child: Lottie.asset('res/drawables/progress_bar_lottie.json', width: 48, height: 48),
                                  )
                              ),
                              Visibility(
                                  visible: _state == LivelinessState.LOCAL_ERROR || _state == LivelinessState.REMOTE_ERROR,
                                  child: _livelinessErrorInfo(liveMotionEvent)
                              )
                            ],
                          );
                        }
                    ),
                  )
                ],
              )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _eventAnimationController.dispose();
    _eventTimer?.cancel();
    super.dispose();
  }

}