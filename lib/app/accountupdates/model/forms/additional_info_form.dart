  import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/address_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_detail_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:rxdart/rxdart.dart';

class AdditionalInfoForm with ChangeNotifier {

  static const FORM_KEY = "account-update-additional-info";

  AdditionalInfoForm() {
    _initState();
  }

  CustomerDetailInfo _info = CustomerDetailInfo();

  final List<Nationality> _nationalities =  [];
  List<Nationality> get nationalities => List.unmodifiable(_nationalities);

  final List<StateOfOrigin> _states =  [];
  List<StateOfOrigin> get states => List.unmodifiable(_states);

  final List<LocalGovernmentArea> _localGovt = [];
  List<LocalGovernmentArea> get localGovt => List.unmodifiable(_localGovt);

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  final _titleController = StreamController<Titles>.broadcast();
  Stream<Titles> get titleStream => _titleController.stream;

  final _maritalStatusController = StreamController<MaritalStatus>.broadcast();
  Stream<MaritalStatus> get maritalStatusStream => _maritalStatusController.stream;

  final _religionController = StreamController<Religion>.broadcast();
  Stream<Religion> get religionStream => _religionController.stream;

  final _nationalityController = StreamController<Nationality>.broadcast();
  Stream<Nationality> get nationalityStream => _nationalityController.stream;

  final _stateOfOriginController = StreamController<StateOfOrigin?>.broadcast();
  Stream<StateOfOrigin?> get stateOfOriginStream => _stateOfOriginController.stream;

  final _localGovtAreaController = StreamController<LocalGovernmentArea?>.broadcast();
  Stream<LocalGovernmentArea?> get localGovtAreaStream => _localGovtAreaController.stream;

  final _employmentStatusController = StreamController<EmploymentStatus>.broadcast();
  Stream<EmploymentStatus> get employmentStatusStream => _employmentStatusController.stream;

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;

  Timer? _debouncer;

  /// Initializes the state of the profile form
  void _initState() {
    final formStreams = [
      titleStream,
      maritalStatusStream,
      religionStream,
      nationalityStream,
      localGovtAreaStream,
      employmentStatusStream,
    ];

    this._isValid = Rx.combineLatest(formStreams, (values) {
      _isFormValid = _isTitleValid(displayError: false)
          && _isMaritalStatusValid(displayError: false)
          && _isReligionValid(displayError: false)
          && _isNationalityValid(displayError: false)
          && _isLocalGovtValid(displayError: false)
          && _isEmploymentStatusValid(displayError: false);
      return _isFormValid;
    }).asBroadcastStream();

    //Register auto-save
    this._subscribeFormToAutoSave([...formStreams]);
  }

  void onTitleChange(Titles? title) {
    _info.title = title?.title;
    _titleController.sink.add(title ?? titles.first);
    _isTitleValid(displayError: true);
  }

  bool _isTitleValid({bool displayError = false}) {
    final isValid = _info.title != null && _info.title?.isNotEmpty == true;
    if (displayError && !isValid) _titleController.sink.addError("Title is required");
    return isValid;
  }

  void onMaritalStatusChange(MaritalStatus? mStatus) {
    _info.maritalStatus = mStatus?.maritalStatus;
    _maritalStatusController.sink.add(mStatus ?? maritalStatuses.first);
    _isMaritalStatusValid(displayError: true);
  }

  bool _isMaritalStatusValid({bool displayError = false}) {
    final isValid = _info.maritalStatus != null && _info.maritalStatus?.isNotEmpty == true;
    if (displayError && !isValid) _maritalStatusController.sink.addError("Marital status is required");
    return isValid;
  }

  void onReligionChange(Religion? mReligion) {
    _info.religion = mReligion?.religion;
    _religionController.sink.add(mReligion ?? religions.first);
    _isReligionValid(displayError: true);
  }

  bool _isReligionValid({bool displayError = false}) {
    final isValid = _info.religion != null && _info.religion?.isNotEmpty == true;
    if (displayError && !isValid) {
      _religionController.sink.addError("Religion is required");
    }
    return isValid;
  }

  void onNationalityChange(Nationality? mNationality,
      {StateOfOrigin? defaultStateOfOrigin, LocalGovernmentArea? defaultLocalGovt}) {
    if(_info.nationality == mNationality?.code) return;
    _info.nationality = mNationality?.code;
    _nationalityController.sink.add(mNationality!);
    _isNationalityValid(displayError: true);

    _states.clear();
    _states.addAll(mNationality.states ?? []);
    onStateOfOriginChange(defaultStateOfOrigin, defaultLocalGovt: defaultLocalGovt);
  }

  bool _isNationalityValid({bool displayError = false}) {
    final isValid = _info.nationality != null && _info.nationality?.isNotEmpty == true;
    if (displayError && !isValid) {
      _nationalityController.sink.addError("Nationality is required");
    }
    return isValid;
  }

  void onStateOfOriginChange(StateOfOrigin? mStateOfOrigin, {LocalGovernmentArea? defaultLocalGovt}) {
    _stateOfOriginController.sink.add(mStateOfOrigin);
    _info.stateId = mStateOfOrigin?.id;//only needed for auto-save and restoring

    _localGovt.clear();
    _localGovt.addAll(mStateOfOrigin?.localGovernmentAreas ?? []);
    onLocalGovtChange(defaultLocalGovt);
  }

  void onLocalGovtChange(LocalGovernmentArea? localGovernmentArea) {
    _info.localGovernmentAreaOfOriginId = localGovernmentArea?.id;
    _localGovtAreaController.sink.add(localGovernmentArea);
    _isLocalGovtValid(displayError: true);
  }

  bool _isLocalGovtValid({bool displayError = false}) {
    final isValid = _info.localGovernmentAreaOfOriginId != null && _info.localGovernmentAreaOfOriginId != 0;
    if (displayError && !isValid) {
      _localGovtAreaController.sink.addError("Local Govt is required");
    }
    return isValid;
  }

  void onEmploymentStatusChange(EmploymentStatus? mEmploymentStatus) {
    _info.employmentStatus = mEmploymentStatus?.empStatus;
    if(mEmploymentStatus != null) _employmentStatusController.sink.add(mEmploymentStatus);
    _isEmploymentStatusValid(displayError: true);
  }

  bool _isEmploymentStatusValid({bool displayError = false}) {
    final isValid = _info.employmentStatus != null && _info.employmentStatus?.isNotEmpty == true;
    if (displayError && !isValid) {
      _employmentStatusController.sink.addError("Employment status is required");
    }
    return isValid;
  }

  void setAddressInfo(AddressInfo addressInfo) {
    this._info.addressInfo = addressInfo;
  }

  CustomerDetailInfo get customerInfo => _info;

  void setNationalities(List<Nationality> nationalities) {
    this._nationalities.clear();
    this._nationalities.addAll(nationalities);
  }

  void _subscribeFormToAutoSave(List<Stream<dynamic>> streams) {
    streams.forEach((element) {
      element.listen((event) {
        _debouncer?.cancel();
        _debouncer = Timer(Duration(milliseconds: 600), (){
          PreferenceUtil.saveDataForLoggedInUser(FORM_KEY, customerInfo);
        });
      }, onError: (a) {
        //Do nothing
      });
    });
  }

  void restoreFormState() {
    final savedInfo = PreferenceUtil.getDataForLoggedInUser(FORM_KEY);
    final savedCustomerInfo = CustomerDetailInfo.fromJson(savedInfo);

    if(savedCustomerInfo.title != null) {
      onTitleChange(Titles.fromTitle(savedCustomerInfo.title));
    }
    if(savedCustomerInfo.maritalStatus != null) {
      onMaritalStatusChange(MaritalStatus.fromString(savedCustomerInfo.maritalStatus));
    }
    if(savedCustomerInfo.religion != null) {
      onReligionChange(Religion.fromString(savedCustomerInfo.religion));
    }
    if(savedCustomerInfo.employmentStatus != null) {
      onEmploymentStatusChange(EmploymentStatus.fromString(savedCustomerInfo.employmentStatus));
    }

    if(savedCustomerInfo.nationality != null) {
      final nationality = Nationality.fromNationalityCode(
          savedCustomerInfo.nationality, nationalities
      );
      final state = StateOfOrigin.fromId(
          savedCustomerInfo.stateId, nationality?.states ?? []
      );
      final localGovt = LocalGovernmentArea.fromId(
          savedCustomerInfo.localGovernmentAreaOfOriginId, state?.localGovernmentAreas ?? []
      );
      onNationalityChange(nationality, defaultStateOfOrigin: state, defaultLocalGovt: localGovt);
    }
  }

  @override
  void dispose() {
    _titleController.close();
    _maritalStatusController.close();
    _religionController.close();
    _nationalityController.close();
    _stateOfOriginController.close();
    _localGovtAreaController.close();
    _employmentStatusController.close();
    _debouncer?.cancel();
    super.dispose();
  }

}