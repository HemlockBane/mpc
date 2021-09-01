import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';

import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:permission_handler/permission_handler.dart';

import 'liveliness_camera_preview.dart';
import 'liveliness_detection_guide.dart';
import 'liveliness_detector.dart';
import 'model/data/liveliness_verification_for.dart';

class LivelinessVerification extends StatefulWidget {

  final Map<String, dynamic> arguments;

  LivelinessVerification(this.arguments);

  @override
  State<StatefulWidget> createState() => _LivelinessVerification();
}

class _LivelinessVerification extends State<LivelinessVerification> {
  LivelinessDetector? _livelinessDetector;
  Future<void>? _initializedLiveliness;

  Dialog _entryDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: BottomSheets.makeAppBottomSheet2(
          curveBackgroundColor: Colors.white,
          centerBackgroundPadding: 14,
          centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          contentBackgroundColor: Colors.white,
          dialogIcon: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.primaryColor
            ),
            child: SvgPicture.asset('res/drawables/ic_face.svg'),
          ),
          content: ScrollView(
            maxHeight: 400,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Center(
                    child: Text('BVN Face Match',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.textColorBlack)),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    'Your face needs to be verified against your BVN information. Please follow the guidelines below to ensure proper capture.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 16
                    ),
                  ),
                  SizedBox(height: 26,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.primaryColor.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                            'RECOMMENDED',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(0.5),
                            ),
                        ),
                        SizedBox(height: 16,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex:1, child: SvgPicture.asset('res/drawables/ic_face_match_brightness.svg')),
                            SizedBox(width: 16,),
                            Expanded(flex:8, child: Text(
                                'Stay in a brightly lit environment',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.textColorBlack
                                )
                            ))
                          ],
                        ),
                        SizedBox(height: 24,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(flex:1, child: SvgPicture.asset('res/drawables/ic_face_match_sunglasses.svg')),
                            SizedBox(width: 16,),
                            Expanded(flex:8, child: Text(
                                'Remove glasses, hats, hijabs, face masks or any other face coverings',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.textColorBlack
                                )
                            ))
                          ],
                        ),
                        SizedBox(height: 24,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex:1, child: SvgPicture.asset('res/drawables/ic_face_match_gesture.svg')),
                            SizedBox(width: 16,),
                            Expanded(flex:8, child: Text('Remain neutral - don’t smile, don’t open your mouth',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.textColorBlack
                                )
                            ))
                          ],
                        ),
                        SizedBox(height: 24,),
                      ],
                    ),
                  ),
                  SizedBox(height: 36),
                  Styles.appButton(
                      elevation: 0,
                      onClick: () {
                        Navigator.of(context).pop();
                        Future.delayed(Duration(milliseconds: 1300), (){
                          _livelinessDetector?.startMotionDetection();
                          _livelinessDetector?.beginCapture();
                        });
                      },
                      text: 'Start Capture'
                  ),
                  SizedBox(height: 24,),
                ],
              ),
            ),
          ),
      ));
  }

  void _requestCameraPermission() async {
    if(await Permission.camera.request().isGranted) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (mContext) => _entryDialog()
      );
      _initLivelinessDetector();
    } else {
      showInfo(
          context,
          title: "Camera Access Disabled",
          message: "Navigate to phone settings to enable camera access",
          primaryButtonText: "Enable Camera Access",
          onPrimaryClick: () {
            AppSettings.openAppSettings();
          }
      );
    }
  }

  @override
  void initState() {
    _livelinessDetector = LivelinessDetector();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _requestCameraPermission();
    });
  }

  void _initLivelinessDetector() {
    final screenSize = MediaQuery.of(context).size;

    var frameRect = Rect.fromLTRB(45, 60, screenSize.width - 45, screenSize.width * 4/3.15);
    var previewSize = Size(screenSize.width, screenSize.height * (1/3));

    _initializedLiveliness = _livelinessDetector?.initialize(
        frameSize: frameRect, previewSize: previewSize
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              child: FutureBuilder(
                  future: _initializedLiveliness,
                  builder: (mContext, value) {
                    if (value.connectionState != ConnectionState.done) return Container();
                    return AspectRatio(
                      aspectRatio: 3/4,//TODO get the aspect ratio from channel
                      child: LivelinessCameraPreview(_livelinessDetector!),
                    );
                  })
          ),
          Positioned(
            left: 0,
            right: 0,
            child: LivelinessDetectionGuide(
              motionEventStream: _livelinessDetector!.motionEventStream,
              callback: _livelinessDetector!,
              verificationFor: widget.arguments["verificationFor"] as LivelinessVerificationFor,
              arguments: widget.arguments,
            ),
          )
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _livelinessDetector?.dispose();
    super.dispose();
  }

}
