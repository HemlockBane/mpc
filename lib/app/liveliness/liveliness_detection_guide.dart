import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_camera_frame_painter.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_error.dart';
import 'package:moniepoint_flutter/app/liveliness/model/behaviors/onboarding_liveliness_validation_behavior.dart';
import 'package:moniepoint_flutter/app/liveliness/viewmodels/liveliness_verification_viewmodel.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/client_error.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

import 'liveliness_detector.dart';
import 'liveliness_verification.dart';


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

enum ErrorType {
  LOCAL, REMOTE
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

  Timer? _faultChecker;

  bool _hasCaptureStarted = false;
  bool _isProcessing = true;
  int _displayState = 0; //0 NONE, ERROR_STATE = -1 ,INFO_STATE = 1
  ErrorType _errorType = ErrorType.LOCAL;
  String errorMessage = "";


  void _processEvents(LivelinessMotionEvent motionEvent) {
    if(_motionDetectedEvent != null || _displayState == -1) return;

    if(_previousMotionEvent == motionEvent.eventType && _faultChecker?.isActive == true){
      return;
    }
    if(_previousMotionEvent != motionEvent.eventType && _faultChecker?.isActive == true){
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
      _faultChecker?.cancel();
      _startTimer();
    } else if(_previousMotionEvent == null || _faultChecker?.isActive == false) {
      _previousMotionEvent = motionEvent.eventType;
      _faultChecker?.cancel();
      _startTimer();
    }

    if(motionEvent.eventType == CameraMotionEvent.FirstCaptureEvent) {
      _firstCaptureEvent = motionEvent;
    }
    if(motionEvent.eventType == CameraMotionEvent.MotionDetectedEvent) {
      _motionDetectedEvent = motionEvent;
      _eventAnimationController.reverse();
      _faultChecker?.cancel();
      _validateFaceMatch();
    }
  }

  void _restartCapture() async {
    _isProcessing = true;
    _firstCaptureEvent = null;
    _motionDetectedEvent = null;
    _previousMotionEvent = null;
    _hasCaptureStarted = false;
    _displayState = 0;
    _errorType = ErrorType.LOCAL;
    errorMessage = "";
    _faultChecker?.cancel();
    await widget.callback.restart();
  }

  void _validateFaceMatch() async {
    final viewModel = Provider.of<LivelinessVerificationViewModel>(context, listen: false);
    switch(widget.verificationFor) {
      case LivelinessVerificationFor.ON_BOARDING:
        final validationBehavior = OnboardingLivelinessValidationBehavior(viewModel, widget.arguments);
        try {
          final response = await validationBehavior.validate(
              _firstCaptureEvent?.eventData as String,
              _motionDetectedEvent?.eventData as String
          );
          if (response != null) {
            _responseHandler(response.livelinessError, response.faceMatchError);
          } else {
            Navigator.of(context).pop(response);
          }
        } catch(e) {
          print(e);
          setState(() {_isProcessing = false;});
          _showGenericError(e.toString());
        }
        break;
    }
  }

  void _responseHandler(LivelinessError? livelinessError, ClientError? faceMatchError) {
    if(livelinessError != null && livelinessError.errors?.isNotEmpty == true) {
      final errors = livelinessError.errors ?? [];
      final error = errors.first;
      _displayState = -1;
      _errorType = ErrorType.REMOTE;
      errorMessage = "${error.code}";
      setState(() {_isProcessing = false;});
    } else if(faceMatchError != null && faceMatchError.message?.isNotEmpty == true) {
      _showGenericError(faceMatchError.message);
      setState(() {_isProcessing = false;});
    }
  }

  void _showGenericError(String? message) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) {
          return BottomSheets.displayErrorModal(context, message: message, onClick: (){
            Navigator.of(context).pop();
            _restartCapture();
          }, buttonText: "Try Again");
        }
    );
  }

  void _startTimer() {
    _faultChecker = Timer.periodic(Duration(seconds: 5), (timer)  {
      _faultChecker?.cancel();
      if(_previousMotionEvent == CameraMotionEvent.NoFaceDetectedEvent) {
        _displayState = -1;
        widget.callback.pauseDetection().then((value) => "");
      } else if (_previousMotionEvent == CameraMotionEvent.NoMotionDetectedEvent){
        _displayState = (timer.tick > 1) ? -1 : 1;
        if(_displayState == -1) {
          widget.callback.pauseDetection().then((value) => "");
        }
        if(_displayState == 1) {
          Future.delayed(Duration(milliseconds: 200), () => _eventAnimationController.forward());
        }
      }
    });
  }

  initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
  }


  Widget _livelinessInfo(LivelinessMotionEvent motionEvent) {
    final infoMessage = (motionEvent.eventType == CameraMotionEvent.NoFaceDetectedEvent)
        ? "Checking for face..."
        : "";
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
              child: AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _controller.value * 2 * pi,
                      child: child,
                    );
                  },
                  child: SvgPicture.asset('res/drawables/ic_face_match_progress.svg'),
              )
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
    if(_errorType == ErrorType.REMOTE) {
      return errorMessage;
    }
    if(_previousMotionEvent == CameraMotionEvent.NoFaceDetectedEvent) {
      return "No Face Detected";
    }
    if(_previousMotionEvent == CameraMotionEvent.NoMotionDetectedEvent){
        return "No Motion Detected";
    }
    return "";
  }

  void _tryAgain() {
    if(_errorType == ErrorType.REMOTE) {
      return _restartCapture();
    }
    _displayState = 0;
    _errorType = ErrorType.LOCAL;
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
                'Nod so we can capture \nyour face properly',
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

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
            stream: widget.motionEventStream,
            builder: (mContext, AsyncSnapshot<LivelinessMotionEvent> motionEvent) {
              if(motionEvent.hasData && _hasCaptureStarted == false) _hasCaptureStarted = true;

              final liveMotionEvent = (motionEvent.hasData)
                  ? motionEvent.data ?? LivelinessMotionEvent.none()
                  : LivelinessMotionEvent.none();

              _processEvents(liveMotionEvent);

              print("Logging Motion Event ${liveMotionEvent.eventType}");
              return Stack(
                children: [
                  Positioned(
                    top:0,
                    left: 0,
                    right:0,
                    bottom: 0,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: SvgPicture.asset('res/drawables/ic_transparent_camera_preview.svg',),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CustomPaint(
                      painter: LivelinessCameraFramePainter(_getFrameColor(liveMotionEvent)),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: _hasCaptureStarted == false,
                            child: Text(
                              'Position your face within \nthe frame then begin capture',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16
                              ),
                            )),
                        Visibility(
                            visible: _firstCaptureEvent != null && _hasCaptureStarted && _displayState == 1,
                            child: FadeTransition(
                              opacity: _motionInfoAnimation,
                              child: _motionInfoWidget(),
                            )
                        ),
                        SizedBox(height: 100,),
                        Visibility(
                            visible: _hasCaptureStarted == false,
                            child: Styles.appButton(
                                onClick: () => widget.callback.startMotionDetection(),
                                text: "Begin Capture",
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
                            )
                        ),
                        Visibility(
                          //@see _displayState to get the values meaning
                            visible: _hasCaptureStarted && (_displayState == 0 || _displayState == 1) && _isProcessing,
                            child: _livelinessInfo(liveMotionEvent)
                        ),
                        Visibility(
                          //@see _displayState to get the values meaning
                            visible: _hasCaptureStarted && _displayState == -1,
                            child: _livelinessErrorInfo(liveMotionEvent)
                        )
                      ],
                    ),
                  )
                ],
              );
            }
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _eventAnimationController.dispose();
    _faultChecker?.cancel();
    super.dispose();
  }

}