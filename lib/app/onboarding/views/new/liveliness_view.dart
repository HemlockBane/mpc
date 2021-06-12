import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

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
import 'package:moniepoint_flutter/core/models/system_configuration.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:provider/provider.dart';

class LivelinessScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _LivelinessScreen();

}

class _LivelinessScreen extends State<LivelinessScreen> {

  static const platform = const MethodChannel('moniepoint.flutter.dev/liveliness');

  late LivelinessViewModel _viewModel;
  late String? bvn;

  Timer? _cameraTimer;
  Timer? _countDownTimer;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  CameraLensDirection? _facingCamera;
  XFile? _lastImageCaptured;
  int _numberOfCameras = 0;

  bool _isCameraReady = false;
  bool _isProcessingImage = false;
  bool _isCapturingCompleted = false;
  bool _isCapturingStarted = false;
  bool _enableRetry = false;

  bool _isLoading = false;
  int _defaultDelayTime = 500;

  String imageInfo = "";

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    _numberOfCameras = cameras.length;
    final _camera = (_numberOfCameras > 1)
        ? cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front)
        : cameras.first;
    _facingCamera = _camera.lensDirection;
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
    _countDownTimer = Timer(Duration(seconds: 10), () {
      var currentGesture = _viewModel.currentCheck?.name;
      if(currentGesture == startingGesture && !_isCapturingCompleted) {
        //We have waited for more than 10seconds
        setState(() {
          _enableRetry = true;
          _viewModel.updateCurrentCheckState(CheckState.FAIL, message: "Failed validating $startingGesture");
          _cameraTimer?.cancel();
          _countDownTimer?.cancel();
        });
      }
    });
  }

  void startImageCapturing() async {
    await _initializeControllerFuture;
    setState(() {
      _isCapturingStarted = true;
      _viewModel.nextCheck();
      _isCapturingCompleted = false;
      _enableRetry = false;
      _updateImageProcessStatus(false);
    });

    _cameraTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if(_isProcessingImage || _isCapturingCompleted) return;

      _updateImageProcessStatus(true);

      _lastImageCaptured = await _controller?.takePicture();

      if(_lastImageCaptured == null) return _updateImageProcessStatus(false);

      final imageBytes = await FlutterImageCompress.compressWithFile(_lastImageCaptured!.path, quality: 30, keepExif: true);

      // setState(() {
      //   imageInfo = "Sending Image: ${imageBytes!.lengthInBytes / 1024} KB";
      // });

      final startTime = DateTime.now();

      final result = await platform.invokeMethod('analyzeImage', {"imageByte": imageBytes});

      print(DateTime.now().difference(startTime).inMilliseconds);
      // setState(() {
      //   imageInfo = "";
      // });

      // print("Completed $result");
      if(result is Map && result.containsKey("error")) {
        _updateImageProcessStatus(false);
        return;
      }

      /// There's no point validating when already in retry mode
      if(!_enableRetry) {
        validateCallbackResult(result, _lastImageCaptured);
        startCountDownTimer();
      }
    });
  }
  
  void _updateImageProcessStatus(bool status) {
    _isProcessingImage = status;
  }

  void validateCallbackResult(dynamic result, XFile? image) {
    if (result == null || result is! Map || _isCapturingCompleted) {
      _updateImageProcessStatus(false);
      return;
    }

    print(result);

    if (result.keys.isEmpty) {
      _updateImageProcessStatus(false);
      return _viewModel.updateCurrentCheckState(CheckState.FAIL, message: "No face detected");
    }

    /// let's check if the general problems are solved
    // setState(() {
    //   imageInfo = "Validating General Problems";
    // });
    final passesGeneralProblems = validateGeneralProblems(result);
    if (!passesGeneralProblems) {
      _updateImageProcessStatus(false);
      return;
    }

    final challenge = _viewModel.nextCheck();

    if(challenge != null) {
      // setState(() {
      //   imageInfo = "Validating Challenge ${challenge.name}";
      // });
      final isChallengeValid = validateChallenge(challenge, result);

      if(isChallengeValid) {
        _countDownTimer?.cancel();
        _viewModel.addSuccessfulChallenge(challenge.name!.replaceAll(" ", ""), image?.path);
      }

      /// We are waiting a bit here so we can give room to display the success message
      Future.delayed(Duration(milliseconds: _defaultDelayTime), () {
        if (!_enableRetry) _viewModel.nextCheck();
        _updateImageProcessStatus(false);
      });
      return;
    } else {
      /// Do we have a good profile picture now?
      if(!_viewModel.hasProfilePicture) {
        _updateImageProcessStatus(false);
        _viewModel.addMoreChecks(_viewModel.profilePictureCriteria!);
        return;
      }
      print('Challenge Completed');
      uploadImage();
      _cameraTimer?.cancel();
      _countDownTimer?.cancel();
      setState(() {
        _isCapturingCompleted = true;
      });
    }

    _updateImageProcessStatus(false);
  }

  bool compare<T extends num>(T operand1, T operand2, Operator? operator, {T? rangeValue}) {
    switch(operator) {
      case Operator.LESS_THAN:
        return operand1 < operand2;
      case Operator.GREATER_THAN:
        return operand1 > operand2;
      case Operator.LESS_THAN_OR_EQUAL_TO:
        return operand1 <= operand2;
      case Operator.GREATER_THAN_OR_EQUAL_TO:
        return operand1 >= operand2;
      case Operator.EQUAL_TO:
        return operand1 == operand2;
      case null:
        return false;
      case Operator.RANGE:
        if(rangeValue == null) throw Exception(
            "Specify the range value, operand1 and operand2 serves as start and end values of the range"
        );
        return rangeValue >= operand1 && rangeValue <= operand2;
    }
  }

  bool validateChallenge(Liveliness challenge, Map<dynamic, dynamic> result) {
    bool isValid = true;
    final criteria = challenge.criteria;
    final challengeName = challenge.name!.replaceAll(" ", "");
    var item = result[criteria.name.toLowerCase()] as Map;

    final criteriaYaw = criteria.yaw;

    if (criteria.name.toLowerCase() == 'pose') {
      if(criteriaYaw == null) isValid = false; // if what we receive from the backend is null let's bounce
      else if ((challengeName == 'LookLeft' || challengeName == 'LookRight') && _facingCamera == CameraLensDirection.back) {
        print("Challenge Name: $challengeName -->>> AWS Yaw => ${item['yaw']} --->>>> Criteria Yaw => ${criteriaYaw.singleValue}");
        isValid = compare<num>(item['yaw'] as num, criteriaYaw.singleValue!, criteriaYaw.livelinessComparator);
      }
      else if ((challengeName == 'LookLeft' || challengeName == 'LookRight') && _facingCamera == CameraLensDirection.front) {
        print("Challenge Name: $challengeName -->>> AWS Yaw => ${-1 * (item['yaw'] as num)} --->>>> Criteria Yaw => ${(criteriaYaw.singleValue as num)} --->> Comparator => ${criteriaYaw.livelinessComparator}");
        isValid = compare<num>(-1 * (item['yaw'] as num), criteriaYaw.singleValue!, criteriaYaw.livelinessComparator);
      }
      else {
        if(challengeName == _viewModel.profilePictureCriteria?.name?.replaceAll(" ", "")) {
          isValid = isLookingStraight(item, criteria);
        }
      }
    } else {
      isValid = item['value'];
    }
    // setState(() {
    //   imageInfo = "Challenge for ${challenge.name} ended with status $isValid";
    // });
    return isValid;
  }

  bool validateGeneralProblems(Map<dynamic, dynamic> result) {
    bool isValid = true;

    var generalProblems = _viewModel.generalProblems;

    //check the number of faces present
    if(result.containsKey("numberOfFaces") && result["numberOfFaces"] > 1) {
      _viewModel.updateCurrentCheckState(CheckState.FAIL, message: "Please, Take a selfie of yourself only.");
      return false;
    }

    final currentCheck = _viewModel.currentCheck;
    final currentCriteriaName = currentCheck?.criteria.name.toLowerCase();

    for(int i = 0; i < generalProblems.length; i++) {
      final element = generalProblems[i];
      final criteria = element.criteria;
      final keyName = criteria.name.toLowerCase();

      /// We skip the check if the current challenge is requesting a criteria in general problems
      if (!result.containsKey(keyName) || currentCriteriaName == keyName) continue;

      /// Amplify might treat smile as mouth open and vice-versa so we simple just ignore
      if((currentCriteriaName == "smile" || currentCriteriaName == "mouthopen")
          && (keyName == "smile" || keyName == "mouthopen")) {
        continue;
      }

      final facialFeature = result[keyName];

      if (!facialFeature.containsKey("value")) continue;

      final value = facialFeature["value"] as bool;
      final confidence = (facialFeature["confidence"] as double?) ?? 100;
      final criteriaConfidence = criteria.confidence;

      if(value != criteria.value) {
        if(criteriaConfidence != null && compare<num>(confidence, criteriaConfidence.singleValue??99,
            criteriaConfidence.livelinessComparator)) {
          continue;
        }

        _viewModel.updateCurrentCheckState(CheckState.FAIL, message: element.description ?? "");
        _countDownTimer?.cancel();
        isValid = false;
        break;
      }
    }

    if(isValid && result.containsKey("pose") && _viewModel.profilePicturePath == null) {
      findProfilePictureMatch(result["pose"]);
    }
    return isValid;
  }

  bool isLookingStraight(Map<dynamic, dynamic> pose, Criteria criteria) {
    print("cPitch ${pose['pitch']} -> criteriaPos ${criteria.pitch?.start} -> criteriaNegative ${criteria.pitch?.end}");
    print("cYaw ${pose['yaw']} -> criteriaPos ${criteria.yaw?.start} -> criteriaNegative ${criteria.yaw?.end}");
    print("cRoll ${pose['roll']} -> criteriaPos ${criteria.roll?.start} -> criteriaNegative ${criteria.roll?.end}");
    final pitchCriteria = criteria.pitch;
    final yawCriteria = criteria.yaw;
    final rollCriteria = criteria.roll;

    if(pitchCriteria == null || yawCriteria == null || rollCriteria == null) return false;

    final isPitchValid = (pitchCriteria.livelinessComparator == Operator.RANGE)
        ? compare<num>(pitchCriteria.start!, pitchCriteria.end!, pitchCriteria.livelinessComparator, rangeValue: pose['pitch'] as num)
        : compare<num>(pose['pitch'] as num, pitchCriteria.singleValue!, pitchCriteria.livelinessComparator);

    final isYawValid = (yawCriteria.livelinessComparator == Operator.RANGE)
        ? compare<num>(yawCriteria.start!, yawCriteria.end!, yawCriteria.livelinessComparator, rangeValue: pose['yaw'] as num)
        : compare<num>(pose['yaw'] as num, yawCriteria.singleValue!, yawCriteria.livelinessComparator);

    final isRollValid = (rollCriteria.livelinessComparator == Operator.RANGE)
        ? compare<num>(rollCriteria.start!, rollCriteria.end!, rollCriteria.livelinessComparator, rangeValue: pose['roll'] as num)
        : compare<num>(pose['roll'] as num, rollCriteria.singleValue!, rollCriteria.livelinessComparator);

    return isPitchValid && isYawValid && isRollValid;
  }

  void findProfilePictureMatch(Map<dynamic, dynamic> pose) {
    final criteria = _viewModel.profilePictureCriteria!.criteria;
    var isValid = isLookingStraight(pose, criteria);

    if(isValid) {
      _viewModel.addSuccessfulChallenge(
          _viewModel.profilePictureCriteria!.name!.replaceAll(" ", ""),
          _lastImageCaptured?.path,
          updateState: false
      );
    }
  }

  void uploadImage() {
    _viewModel.compareAndGetImageReference(this.bvn ?? "").listen((event) {
      if(!mounted) return;
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
      if (event is Success<LivelinessCompareResponse>) {
        setState(() => _isLoading = false);

        final Widget bottomSheetView;

        if (event.data?.status == "FAILED") {
          bottomSheetView = BottomSheets.displayWarningDialog("Unmatched Image", event.data!.errorMessage ?? "", () {
            Navigator.of(context).pop();
            Navigator.of(context).pop({
              "reference": event.data!.reference,
              "livelinessCheck": event.data?.status
            });
          });
        } else {
          bottomSheetView = BottomSheets.displaySuccessModal(context, title: "Success", message: "BVN Image successfully matched", onClick: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop({
              "reference": event.data!.reference,
              "livelinessCheck": event.data?.status
            });
          });
        }

        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => bottomSheetView
        );
      }
    });
  }

  void _loadSystemConfig() {
    String? value = PreferenceUtil.getValueForLoggedInUser(PreferenceUtil.SYSTEM_CONFIG);
    List<dynamic> configs = (value != null) ? jsonDecode(value) : [];
    List<SystemConfiguration> configurations = configs.map((e) => SystemConfiguration.fromJson(e)).toList();
    List<SystemConfiguration>? livelinessConfig = configurations.where((element) => element.name == "liveliness.test.interval").toList();

    if(livelinessConfig.isEmpty) return;

    try {
      print(jsonEncode(livelinessConfig));
      _defaultDelayTime = int.parse(livelinessConfig.first.value!);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _viewModel = LivelinessViewModel();
    super.initState();
    _loadSystemConfig();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel.getLivelinessChecks().listen((event) {
        if((event is Loading || event is Success) && (event.data != null && !_isCapturingStarted)) startImageCapturing();
        if(event is Error) {}
      });
      _initCamera();
    });
  }

  Color _getProgressColor(bool hasError) {
    if(_isCapturingCompleted) return Colors.solidGreen;
    return hasError ? Colors.red.withOpacity(0.7) : Colors.primaryColor;
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
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation(_getProgressColor(a.hasError)),
                    backgroundColor: Colors.deepGrey.withOpacity(0.5),
                    value: a.hasError ? 1 : value,
                  );
                });
          }),
    );
  }

  Widget cameraView() {
    final size = MediaQuery.of(context).size.width - 60;
    return SizedBox(
      width: size,
      height: size,
      child:  Stack(
        children: [
          _progressiveView(),
          Transform.scale(
            scale: 1,
            child: Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 2),
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Container(
                      width: size / _controller!.value.aspectRatio,
                      height: size /_controller!.value.aspectRatio,
                      child: (!_isCapturingCompleted) ? CameraPreview(_controller!) : _lastCaptureImage(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(_isCapturingCompleted) SizedBox(
            width: size,
            height: size,
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.solidGreen.withOpacity(0.6),
              ),
              child: Center(
                child: SvgPicture.asset ('res/drawables/ic_check_mark.svg' ,color: Colors.white.withOpacity(0.6),),
              ),
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
      return Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18));
    } else if(state == CheckState.SUCCESS) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('res/drawables/liveliness_passed_icon.svg'),
          SizedBox(width: 8),
          Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.solidGreen, fontWeight: FontWeight.bold,fontSize: 18),)
        ],
      );
    }
    return Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.bold, fontSize: 18));
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
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    initialData: Tuple(CheckState.INFO, ''),
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
              Visibility(
                  visible: _isLoading,
                  child: Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.9,
                        valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
                      ),
                    ),
                  )
              ),
              if(_enableRetry) SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                  elevation: 0,
                  text: 'Retry',
                  onClick: (_isLoading) ? null : () => startImageCapturing()
              )),
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