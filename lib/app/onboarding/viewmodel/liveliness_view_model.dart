import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_compare_response.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_criteria.dart';
import 'package:moniepoint_flutter/app/onboarding/model/services/liveliness_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/tuple.dart';

enum CheckState {
  SUCCESS, FAIL, INFO
}

class LivelinessViewModel with ChangeNotifier {
  late LivelinessServiceDelegate _delegate;

  double _progressValue = 0.0;
  
  double _previousProgressValue = 0.0;
  double get previousProgressValue => _previousProgressValue;

  StreamController<double> _progressController = StreamController.broadcast();
  Stream<double> get progressStream => _progressController.stream;

  StreamController<Tuple<CheckState, String>> _checkStateController = StreamController.broadcast();
  Stream<Tuple<CheckState, String>> get checkStateStream => _checkStateController.stream;

  ///Criteria Name to File Path
  final _imageMap = Map<String, String>();

  List<Liveliness> _liveliness = [];
  ListQueue<Liveliness> get _livelinessChecks => ListQueue.from(_liveliness);
  ListQueue<Liveliness>? _internalChecks;

  Liveliness? _currentCheck;
  Liveliness? get currentCheck => _currentCheck;

  //Problems
  final List<Liveliness> generalProblems = [];

  Liveliness? _profilePictureCriteria;
  Liveliness? get profilePictureCriteria => _profilePictureCriteria;
  String? get profilePicturePath => _imageMap[_profilePictureCriteria?.name?.replaceAll(" ", "")];

  LivelinessViewModel({LivelinessServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<LivelinessServiceDelegate>();
  }

  Liveliness? nextCheck() {
    if (_currentCheck != null && !_imageMap.containsKey(_currentCheck!.name!.replaceAll(" ", ""))) {
      updateCurrentCheckState(CheckState.INFO);
      return _currentCheck;
    }

    _internalChecks = _internalChecks ?? _livelinessChecks;

    if(_internalChecks!.isNotEmpty) {
      _currentCheck = _internalChecks?.removeFirst();
      updateCurrentCheckState(CheckState.INFO);
      return _currentCheck;
    }
    return null;
  }

  void addMoreChecks(Liveliness liveliness) {
    var checkList = _internalChecks ?? _livelinessChecks;
    checkList.add(liveliness);
    nextCheck();
    _updateProgress();
  }

  void updateCurrentCheckState(CheckState state, {String message = ""}) {
    if(state == CheckState.INFO) {
      _progressController.sink.add(_progressValue); //clear errors if any
      return _checkStateController.sink.add(Tuple(state, _currentCheck?.description ?? message));
    }

    if(state == CheckState.FAIL) {
      _progressController.sink.addError(message);
    }

    _checkStateController.sink.add(Tuple(state, message));
  }

  void _updateProgress() {
    var progressLength = _liveliness.length + ((profilePictureCriteria != null) ? 1 : 0);
    double progressiveValue  = (1 / progressLength);
    _previousProgressValue = _progressValue;
    _progressValue = _imageMap.length * progressiveValue;
    _progressController.sink.add(_progressValue);
  }

  void addSuccessfulChallenge(String criteriaName, String? filePath, {bool updateState = true}) {
    if(filePath == null) return;

    this._imageMap[criteriaName] = filePath;
    //Update and calculate progress Value
    if(updateState) {
      _updateProgress();
      updateCurrentCheckState(CheckState.SUCCESS, message: _currentCheck?.description ?? "");
    }
  }

  bool get hasProfilePicture => _imageMap.containsKey(profilePictureCriteria?.name?.replaceAll(" ", ""));

  Stream<Resource<LivelinessChecks>> getLivelinessChecks() {
    return _delegate.getLivelinessChecks().map((event) {
      if (event is Success) {
        this.generalProblems.addAll(event.data?.generalProblems ?? []);
        this._liveliness.addAll(event.data?.challenges ?? []);
        this._profilePictureCriteria = event.data?.profilePictureCriteria;
      }
      return event;
    });
  }

  Stream<Resource<LivelinessCompareResponse>> compareAndGetImageReference(String bvn) {
    final profilePictureName = _profilePictureCriteria?.name?.replaceAll(" ", "");
    if(!_imageMap.containsKey(profilePictureName)) return Stream.empty();
    final imagePath = _imageMap[profilePictureName]!;

    return _delegate.compareAndGetImageReference(imagePath, bvn).map((event) {
      if (event is Success) {

      }
      return event;
    });
  }

  @override
  void dispose() {
    _progressController.close();
    _checkStateController.close();
    super.dispose();
  }
}