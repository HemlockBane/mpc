import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/next_of_kin_info.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/forms/customer_address_form.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:rxdart/rxdart.dart';

import '../drop_items.dart';

/// @author Paul Okeke
class NextOfKinForm with ChangeNotifier, Validators {

  static const FORM_KEY = "account-update-next-of-kin-info";
  static const ADDRESS_FORM_KEY = "account-update-next-of-kin-address";

  NextOfKinForm() {
    _info.addressInfo = addressForm.getAddressInfo;
    _initState();
  }

  CustomerAddressForm addressForm = CustomerAddressForm(
      formKey: ADDRESS_FORM_KEY,
      requiresMailingAddress: false
  );

  NextOfKinInfo _info = NextOfKinInfo();

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  final _firstNameController = StreamController<String>.broadcast();
  Stream<String> get firstNameStream => _firstNameController.stream;

  final _lastNameController = StreamController<String>.broadcast();
  Stream<String> get lastNameStream => _lastNameController.stream;

  final _middleNameController = StreamController<String>.broadcast();
  Stream<String> get middleNameStream => _middleNameController.stream;

  final _phoneNumberController = StreamController<String>.broadcast();
  Stream<String> get phoneNumberStream => _phoneNumberController.stream;

  final _emailAddressController = StreamController<String>.broadcast();
  Stream<String> get emailStream => _emailAddressController.stream;

  final _relationshipController = StreamController<Relationship>.broadcast();
  Stream<Relationship> get relationshipStream => _relationshipController.stream;

  final _dateOfBirthController = StreamController<String>.broadcast();
  Stream<String> get dateOfBirthStream => _dateOfBirthController.stream;

  bool _isFormValid = false;
  bool get isFormValid => _isFormValid;

  Timer? _debouncer;

  void _initState() {
    final formStreams = [
      firstNameStream,
      lastNameStream,
      phoneNumberStream,
      emailStream,
      relationshipStream,
      dateOfBirthStream,
      addressForm.isValid
    ];

    this._isValid = Rx.combineLatest(formStreams, (values) {
      _isFormValid = _isFirstNameValid(displayError: false)
          && _isLastNameValid(displayError: false)
          // && _isMiddleNameValid(displayError: false)
          && _isPhoneNumberValid(displayError: false)
          && _isEmailAddressValid(displayError: false)
          && _isRelationshipValid(displayError: false)
          && _isDateOfBirthValid(displayError: false);

      return _isFormValid;
    }).asBroadcastStream();

    this._subscribeFormToAutoSave([...formStreams, middleNameStream]);
  }

  void onFirstNameChange(String? firstName) {
    _info.nextOfKinFirstName = firstName;
    _firstNameController.sink.add(firstName ?? "");
    _isFirstNameValid(displayError: true);
  }

  bool _isFirstNameValid({bool displayError = false}) {
    final isValid = _info.nextOfKinFirstName != null && _info.nextOfKinFirstName?.isNotEmpty == true;
    if (displayError && !isValid) _firstNameController.sink.addError("First name is required");
    return isValid;
  }

  void onLastNameChange(String? lastName) {
    _info.nextOfKinLastName = lastName;
    _lastNameController.sink.add(lastName ?? "");
    _isLastNameValid(displayError: true);
  }

  bool _isLastNameValid({bool displayError = false}) {
    final isValid = _info.nextOfKinLastName != null && _info.nextOfKinLastName?.isNotEmpty == true;
    if (displayError && !isValid) _lastNameController.sink.addError("Last name is required");
    return isValid;
  }

  void onMiddleNameChange(String? lastName) {
    _info.nextOfKinMiddleName = lastName;
    _middleNameController.sink.add(lastName ?? "");
    _isMiddleNameValid(displayError: false/*Modify if middle name is required*/);
  }

  bool _isMiddleNameValid({bool displayError = false}) {
    final isValid = _info.nextOfKinMiddleName != null && _info.nextOfKinMiddleName?.isNotEmpty == true;
    if (displayError && !isValid) _middleNameController.sink.addError("Middle name is required");
    return true;
  }

  void onPhoneNumberChange(String? phoneNumber) {
    print("Phone Number Change => $phoneNumber");
    _info.nextOfKinPhoneNumber = phoneNumber;
    _phoneNumberController.sink.add(phoneNumber ?? "");
    _isPhoneNumberValid(displayError: true);
  }

  bool _isPhoneNumberValid({bool displayError = false}) {
    final isValid = (_info.nextOfKinPhoneNumber?.length ?? 0) > 1;
    if (displayError && !isValid) {
      _phoneNumberController.sink.addError(
          (_info.nextOfKinPhoneNumber == null || _info.nextOfKinPhoneNumber!.isEmpty)
              ? 'Phone number is required'
              : 'Invalid Phone number');
    }
    return isValid;
  }

  void onEmailAddressChange(String? emailAddress) {
    _info.nextOfKinEmail = emailAddress;
    _emailAddressController.sink.add(emailAddress ?? "");
    _isEmailAddressValid(displayError: true);
  }

  bool _isEmailAddressValid({bool displayError = false}) {
    final isValid = isEmailValid(_info.nextOfKinEmail);
    if (displayError && !isValid) {
      _emailAddressController.sink.addError(
          (_info.nextOfKinEmail == null || _info.nextOfKinEmail!.isEmpty)
              ? 'Email address is required'
              : 'Invalid Email address');
    }
    return isValid;
  }

  void onRelationshipChange(Relationship? mRelationship) {
    _info.nextOfKinRelationship = mRelationship?.relationship;
    _relationshipController.sink.add(mRelationship ?? relationships.first);
    _isRelationshipValid(displayError: true);
  }

  bool _isRelationshipValid({bool displayError = false}) {
    final isValid = _info.nextOfKinRelationship != null && _info.nextOfKinRelationship?.isNotEmpty == true;
    if (displayError && !isValid) _relationshipController.sink.addError("Relationship is required");
    return isValid;
  }

  void onDateOfBirthChange(String? dateOfBirth) {
    _info.nextOfKinDOB = dateOfBirth;
    _dateOfBirthController.sink.add(dateOfBirth ?? "");
    _isDateOfBirthValid(displayError: true);
  }

  bool _isDateOfBirthValid({bool displayError = false}) {
    final isValid = _info.nextOfKinDOB != null && _info.nextOfKinDOB?.isNotEmpty == true;
    if (displayError && !isValid) _dateOfBirthController.sink.addError("Date of birth is required");
    return isValid;
  }

  NextOfKinInfo get nextOfKinInfo => _info;

  void _subscribeFormToAutoSave(List<Stream<dynamic>> streams) {
    streams.forEach((element) {
      element.listen((event) {
        _debouncer?.cancel();
        _debouncer = Timer(Duration(milliseconds: 600), () {
          PreferenceUtil.saveDataForLoggedInUser(FORM_KEY, _info);
        });
      }, onError: (a) {
        //Do nothing
      });
    });
  }

  void restoreFormState() {
      final savedInfo = PreferenceUtil.getDataForLoggedInUser(FORM_KEY);
      final savedNextOfKin = NextOfKinInfo.fromJson(savedInfo);

      addressForm.restoreFormState();

      if(savedNextOfKin.nextOfKinFirstName != null
          && savedNextOfKin.nextOfKinFirstName?.isNotEmpty == true) {
        onFirstNameChange(savedNextOfKin.nextOfKinFirstName);
      }
      if(savedNextOfKin.nextOfKinMiddleName != null
          && savedNextOfKin.nextOfKinMiddleName?.isNotEmpty == true) {
        onMiddleNameChange(savedNextOfKin.nextOfKinMiddleName);
      }
      if(savedNextOfKin.nextOfKinLastName != null
          && savedNextOfKin.nextOfKinLastName?.isNotEmpty == true) {
        onLastNameChange(savedNextOfKin.nextOfKinLastName);
      }
      if(savedNextOfKin.nextOfKinPhoneNumber != null
          && savedNextOfKin.nextOfKinPhoneNumber?.isNotEmpty == true) {
        onPhoneNumberChange(savedNextOfKin.nextOfKinPhoneNumber);
      }
      if(savedNextOfKin.nextOfKinEmail != null
          && savedNextOfKin.nextOfKinEmail?.isNotEmpty == true) {
        onEmailAddressChange(savedNextOfKin.nextOfKinEmail);
      }
      if(savedNextOfKin.nextOfKinRelationship != null
          && savedNextOfKin.nextOfKinRelationship?.isNotEmpty == true) {
        onRelationshipChange(Relationship.fromString(savedNextOfKin.nextOfKinRelationship));
      }
      if(savedNextOfKin.nextOfKinDOB != null
          && savedNextOfKin.nextOfKinDOB?.isNotEmpty == true) {
        onDateOfBirthChange(savedNextOfKin.nextOfKinDOB);
      }
  }

  @override
  void dispose() {
    _firstNameController.close();
    _lastNameController.close();
    _middleNameController.close();
    _phoneNumberController.close();
    _emailAddressController.close();

    _relationshipController.close();
    _dateOfBirthController.close();

    addressForm.dispose();
    _debouncer?.cancel();
    // addressForm.dispose();
    super.dispose();
  }

}