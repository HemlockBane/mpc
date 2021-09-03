

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/customer_identification_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:rxdart/rxdart.dart';

class CustomerIdentificationForm with ChangeNotifier {

  static const FORM_KEY = "account-update-identification-info";
  static const FORM_FILE_NAME_KEY = "account-update-identification-info-filename";

  CustomerIdentificationForm() {
    _initState();
  }

  CustomerIdentificationInfo _info = CustomerIdentificationInfo();

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  final _idTypeController = StreamController<IdentificationType>.broadcast();
  Stream<IdentificationType> get idTypeStream => _idTypeController.stream;

  final _idNumberController = StreamController<String>.broadcast();
  Stream<String> get idNumberStream => _idNumberController.stream;

  final _issueDateController = StreamController<String>.broadcast();
  Stream<String> get issueDateStream => _issueDateController.stream;

  final _expiryDateController = StreamController<String>.broadcast();
  Stream<String> get expiryDateStream => _expiryDateController.stream;

  final _idImageReferenceController = StreamController<String>.broadcast();
  Stream<String> get idImageReferenceStream => _idImageReferenceController.stream;

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;

  Timer? _debouncer;

  void _initState() {
    final formStreams = [
      idTypeStream,
      idNumberStream,
      issueDateStream,
      expiryDateStream,
      idImageReferenceStream,
    ];

    this._isValid = Rx.combineLatest(formStreams, (values) {
      _isFormValid = _isIdTypeValid(displayError: false)
          && _isIdNumberValid(displayError: false)
          && _isIssueDateValid(displayError: false)
          && _isExpiryDateValid(displayError: false)
          && _isImageReferenceValid(displayError: false);
      return _isFormValid;
    }).asBroadcastStream();

    //Subscribe
    this._subscribeFormToAutoSave(formStreams);
  }

  void onIdentificationTypeChange(IdentificationType? type) {
    _info.identificationType = type?.idType;
    _idTypeController.sink.add(type ?? identificationTypes.first);
    _isIdTypeValid(displayError: true);
  }

  bool _isIdTypeValid({bool displayError = false}) {
    final isValid = _info.identificationType != null && _info.identificationType?.isNotEmpty == true;
    if (displayError && !isValid) _idTypeController.sink.addError("Identification type is required");
    return isValid;
  }

  void onIdentificationNumberChange(String? idNumber) {
    _info.registrationNumber = idNumber;
    _idNumberController.sink.add(idNumber ?? "");
    _isIdNumberValid(displayError: true);
  }

  bool _isIdNumberValid({bool displayError = false}) {
    final isValid = _info.registrationNumber != null && _info.registrationNumber?.isNotEmpty == true;
    if (displayError && !isValid) _idNumberController.sink.addError("Registration Number is required");
    return isValid;
  }

  void onIssueDateChange(String? issueDate) {
    _info.identityIssueDate = issueDate;
    _issueDateController.sink.add(issueDate ?? "");
    _isIssueDateValid(displayError: true);
  }

  bool _isIssueDateValid({bool displayError = false}) {
    final isValid = _info.identityIssueDate != null && _info.identityIssueDate?.isNotEmpty == true;
    if (displayError && !isValid) _issueDateController.sink.addError("Issue date is required");
    return isValid;
  }

  void onExpiryDateChange(String? expiryDate) {
    _info.identityExpiryDate = expiryDate;
    _expiryDateController.sink.add(expiryDate ?? "");
    _isExpiryDateValid(displayError: true);
  }

  bool _isExpiryDateValid({bool displayError = false}) {
    final isValid = _info.identityExpiryDate != null && _info.identityExpiryDate?.isNotEmpty == true;
    if (displayError && !isValid) _expiryDateController.sink.addError("Expiry date is required");
    return isValid;
  }

  void onImageReferenceChanged(String? imageReference, String? fileName) {
    _info.scannedImageRef = imageReference;
    _idImageReferenceController.sink.add(imageReference ?? "");
    _isImageReferenceValid(displayError: true);
  }

  bool _isImageReferenceValid({bool displayError = false}) {
    final isValid = _info.scannedImageRef != null && _info.scannedImageRef?.isNotEmpty == true;
    if (displayError && !isValid) _idImageReferenceController.sink.addError("An uploaded document is required");
    return isValid;
  }

  CustomerIdentificationInfo get identificationInfo => _info;

  void _subscribeFormToAutoSave(List<Stream<dynamic>> streams) {
    streams.forEach((element) {
      element.listen((event) {
        _debouncer?.cancel();
        _debouncer = Timer(Duration(milliseconds: 600), () {
          PreferenceUtil.saveDataForLoggedInUser(FORM_KEY, _info);
          PreferenceUtil.saveValueForLoggedInUser<String>(FORM_FILE_NAME_KEY, "");
        });
      }, onError: (a) {
        //Do nothing
      });
    });
  }

  void restoreFormState() {
    final savedInfo = PreferenceUtil.getDataForLoggedInUser(FORM_KEY);
    final savedIdentificationInfo = CustomerIdentificationInfo.fromJson(savedInfo);

    if(savedIdentificationInfo.identificationType != null) {
      onIdentificationTypeChange(IdentificationType.fromString(savedIdentificationInfo.identificationType));
    }
    if(savedIdentificationInfo.identityExpiryDate != null) {
      onExpiryDateChange(savedIdentificationInfo.identityExpiryDate);
    }
    if(savedIdentificationInfo.identityIssueDate != null) {
      onIssueDateChange(savedIdentificationInfo.identityIssueDate);
    }
    if(savedIdentificationInfo.registrationNumber != null) {
      onIdentificationNumberChange(savedIdentificationInfo.registrationNumber);
    }
    if(savedIdentificationInfo.scannedImageRef != null) {
      onImageReferenceChanged(savedIdentificationInfo.scannedImageRef);
    }
  }
  
  @override
  void dispose() {
    _idTypeController.close();
    _idNumberController.close();
    _issueDateController.close();
    _expiryDateController.close();
    _idImageReferenceController.close();
    _debouncer?.cancel();
    super.dispose();
  }
}