import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_compare_response.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_criteria.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/liveliness_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:provider/provider.dart';

class LivelinessScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _LivelinessScreen();
  }

}

class _LivelinessScreen extends State<LivelinessScreen> {

  static const platform = const MethodChannel('moniepoint.flutter.dev/liveliness');

  late LivelinessViewModel _viewModel;
  late String? bvn;

  Timer? _cameraTimer;
  Timer? _countDownTimer;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  int _facingCamera = 1;
  XFile? _lastImageCaptured;
  int _numberOfCameras = 0;

  bool _isCameraReady = false;
  bool _isProcessingImage = false;
  bool _isCapturingCompleted = false;
  bool _enableRetry = false;

  bool _isLoading = false;

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _numberOfCameras = cameras.length;
    final _camera = (1 == _numberOfCameras) ? cameras.first : cameras.last;
    _controller = CameraController(_camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller?.initialize();
    setState(() {
      _isCameraReady = true;
    });
  }

  @override
  void dispose() {
    _cameraTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void startCountDownTimer() {
    if(_countDownTimer?.isActive == true) return;
    _countDownTimer?.cancel();
    var startingGesture = _viewModel.currentCheck?.name;
    _countDownTimer = Timer(Duration(seconds: 15), () {
      var currentGesture = _viewModel.currentCheck?.name;
      if(currentGesture == startingGesture && !_isCapturingCompleted) {
        //We have waited for more than 10seconds
        _cameraTimer?.cancel();
        _countDownTimer?.cancel();
        setState(() {
          _enableRetry = true;
        });
        _viewModel.updateCurrentCheckState(CheckState.FAIL, message: "Not very sure what you are doing!\nPlease follow the instructions :)");
      }
    });
  }

  void startImageCapturing() async {
    await _initializeControllerFuture;
    setState(() {
      _isCapturingCompleted = false;
      _enableRetry = false;
    });

    _cameraTimer = Timer.periodic(Duration(seconds: 4), (timer) async {
      if(_isProcessingImage) return;
      _updateImageProcessStatus(true);
      _lastImageCaptured = await _controller?.takePicture();
      final imageBytes = await FlutterImageCompress.compressWithFile(_lastImageCaptured!.path, quality: 30);

      final result = await platform.invokeMethod('analyzeImage', {
        "imageByte": imageBytes
      });

      print("Completed $result");
      if(result is Map && result.containsKey("error")) {
        //TODO properly handle the error for the client
        _updateImageProcessStatus(false);
        return;
      }

      validateCallbackResult(result, _lastImageCaptured);
      startCountDownTimer();
    });
  }
  
  void _updateImageProcessStatus(bool status) {
    _isProcessingImage = status;
  }

  void validateCallbackResult(dynamic result, XFile? image) {
    if (result == null || result is! Map) {
      _updateImageProcessStatus(false);
      return;
    }

    if (result.keys.isEmpty) {
      _updateImageProcessStatus(false);
      return _viewModel.updateCurrentCheckState(CheckState.FAIL, message: "No face detected");
    }

    //let's check if the general problems are solved
    final passesGeneralProblems = validateGeneralProblems(result);
    if (!passesGeneralProblems) {
      _updateImageProcessStatus(false);
      return;
    }

    final challenge = _viewModel.nextCheck();

    if(challenge != null) {
      final isChallengeValid = validateChallenge(challenge, result);

      if(isChallengeValid) {
        _countDownTimer?.cancel();
        _viewModel.addSuccessfulChallenge(challenge.name!.replaceAll(" ", ""), image?.path);
      }

      /// We are waiting a bit here so we can give room to display the success message
      Future.delayed(Duration(seconds: 2), () {
        _viewModel.nextCheck();
        _updateImageProcessStatus(false);
      });
      return;
    } else {
      print('Challenge Completed');
      //TODO check if we have a perfect profile picture
      if(!_viewModel.hasProfilePicture) {
        //let's revert and force a profile look straight

        return;
      }
      _cameraTimer?.cancel();
      _countDownTimer?.cancel();
      /// meaning capturing is complete
      setState(() {
        _isCapturingCompleted = true;
      });
    }

    _updateImageProcessStatus(false);
  }

  bool validateChallenge(Liveliness challenge, Map<dynamic, dynamic> result) {
    bool isValid = true;
    final criteria = challenge.criteria;
    final challengeName = challenge.name!.replaceAll(" ", "");
    var item = result[criteria.name.toLowerCase()] as Map;

    if (criteria.name.toLowerCase() == 'pose') {
      if (challengeName == 'LookLeft') {
        isValid = item['yaw'] >= criteria.yaw?.positive;
      } else if (challengeName == "LookRight") {
        isValid = item['yaw'] <= criteria.yaw?.negative;
      } else {
        print(challengeName);
        isValid = (item['pitch'] <= criteria.pitch?.positive && item['pitch'] >= criteria.pitch?.positive) &&
            (item['yaw'] <= criteria.yaw?.positive && item['yaw'] >= criteria.yaw?.positive)&&
            (item['roll'] <= criteria.roll?.positive && item['roll'] >= criteria.roll?.positive);
      }
    } else {
      isValid = item['value'];
    }
    return isValid;
  }

  bool validateGeneralProblems(Map<dynamic, dynamic> result) {
    bool isValid = true;

    var generalProblems = _viewModel.generalProblems;

    for(int i = 0; i < generalProblems.length; i++) {
      final element = generalProblems[i];
      final keyName = element.criteria.name.toLowerCase();

      if (!result.containsKey(keyName)) continue;

      final facialFeature = result[keyName];

      if (!facialFeature.containsKey("value")) continue;

      final value = facialFeature["value"] as bool;

      if(value == true && element.criteria.value == false) {
        _viewModel.updateCurrentCheckState(CheckState.FAIL, message: element.description ?? "");
        isValid = false;
        break;
      }
    }

    //check if it matches
    if(result.containsKey("pose")) findProfilePictureMatch(result["pose"]);

    return isValid;
  }

  void findProfilePictureMatch(Map<dynamic, dynamic> pose) {
    final criteria = _viewModel.profilePictureCriteria!.criteria;
    print("cPitch ${pose['pitch']} -> criteriaPos ${criteria.pitch?.positive} -> criteriaNegative ${criteria.pitch?.negative}");
    print("cYaw ${pose['yaw']} -> criteriaPos ${criteria.yaw?.positive} -> criteriaNegative ${criteria.yaw?.negative}");
    print("cRoll ${pose['roll']} -> criteriaPos ${criteria.roll?.positive} -> criteriaNegative ${criteria.roll?.negative}");
    var isValid = (pose['pitch'] <= criteria.pitch?.positive && pose['pitch'] >= criteria.pitch?.negative) &&
        (pose['yaw'] <= criteria.yaw?.positive && pose['yaw'] >= criteria.yaw?.negative) &&
        (pose['roll'] <= criteria.roll?.positive && pose['roll'] >= criteria.roll?.negative);

    print('Profile Picture $isValid');
    if(isValid) {
      _viewModel.addSuccessfulChallenge(
          _viewModel.profilePictureCriteria!.name!,
          _lastImageCaptured?.path,
          updateState: false
      );
    }
  }

  void uploadImage() {
    _viewModel.compareAndGetImageReference("LookRight", this.bvn??"").listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<LivelinessCompareResponse>) {
        setState(() => _isLoading = false);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
      if(event is Success<LivelinessCompareResponse>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop(event.data!.reference);
      }
    });
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _viewModel = LivelinessViewModel();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel.getLivelinessChecks().listen((event) {
        if(event is Success) startImageCapturing();
      });
      _initCamera();
    });
  }

  Widget _progressiveView() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder(
          initialData:  _viewModel.previousProgressValue,
          stream: _viewModel.progressStream,
          builder: (BuildContext context, AsyncSnapshot<double> a) {
            return TweenAnimationBuilder(tween: Tween<double>(begin: _viewModel.previousProgressValue, end: a.data ?? 0.0),
                duration: const Duration(milliseconds: 1000),
                builder: (BuildContext c, double value, _) {
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                        a.hasError
                            ? Colors.red.withOpacity(0.5)
                            : Colors.primaryColor
                    ),
                    backgroundColor: Colors.deepGrey.withOpacity(0.5),
                    value: a.hasError ? 1 :value,
                  );
                });
          }),
    );
  }

  Widget cameraView() {
    final size = 300.0;
    return SizedBox(
      width: size,
      height: size,
      child:  Stack(
        children: [
          _progressiveView(),
          Container(
            padding: EdgeInsets.all(4),
            width: double.infinity,
            height: double.infinity,//_controller!.value.aspectRatio,
            decoration: BoxDecoration(
                shape: BoxShape.circle
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: (_isCapturingCompleted)
                    ? _lastCaptureImage()
                    : AspectRatio(aspectRatio: 1, child: CameraPreview(_controller!))
            ),
          )
        ],
      ),
    );
  }

  Widget _lastCaptureImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: FileImage(File(_viewModel.profilePicturePath ?? _lastImageCaptured?.path ?? ""))
          )
      ),
    );
  }

  Widget showDisplayableMessage(CheckState state, String message) {
    if(state == CheckState.FAIL) {
      return Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
    } else if(state == CheckState.SUCCESS) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('res/drawables/liveliness_passed_icon.svg'),
          SizedBox(width: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.solidGreen, fontWeight: FontWeight.bold),)
        ],
      );
    }
    return Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    this.bvn = args["bvn"];

    return Provider(
      create: (_) => ChangeNotifierProvider.value(value: _viewModel),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Liveliness Test', style: TextStyle(color: Colors.primaryColor, fontFamily: Styles.defaultFont),),
          backgroundColor: Colors.backgroundWhite,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          elevation: 0,
        ),
        body: Container(
          color: Colors.backgroundWhite,
          child: Column(
            children: [
              SizedBox(
                height: 64,
              ),
              Center(
                  child: FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return cameraView();
                        } else {
                          return Container();
                        }
                      })
              ),
              SizedBox(
                height: 52,
              ),
              Center(
                child: StreamBuilder(
                    initialData: Tuple(CheckState.INFO, 'Analyzing Image...'),
                    stream: _viewModel.checkStateStream,
                    builder: (BuildContext mContext, AsyncSnapshot<Tuple<CheckState, String>> a)  {
                      return (a.hasData)
                          ? showDisplayableMessage(a.data!.first, a.data!.second)
                          : SizedBox();
                    }),
              ),
              SizedBox(
                height: 32,
              ),
              Spacer(),
              if(_enableRetry) Styles.appButton(
                  elevation: 0,
                  buttonStyle: Styles.greyButtonStyle,
                  text: 'Retry',
                  onClick: (_isLoading) ? null : () => startImageCapturing()
              ),
              SizedBox(
                height: 32,
              )
            ],
          ),
        ),
      ),
    );
  }
}