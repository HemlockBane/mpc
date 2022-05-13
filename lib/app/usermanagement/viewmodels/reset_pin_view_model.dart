import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/reset_pin_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../onboarding/model/data/otp.dart';
import '../model/data/reset_otp_validation_response.dart';

class ResetPinViewModel extends BaseViewModel with Validators {

  ResetPinViewModel({UserManagementServiceDelegate? delegate}){
    this._delegate = delegate ?? GetIt.I<UserManagementServiceDelegate>();
  }

  late final UserManagementServiceDelegate _delegate;

  String _otpValidationKey = "";
  String get otpValidationKey => _otpValidationKey;

  String livelinessValidationKey = "";

  BehaviorSubject<String> _newPinSubject = BehaviorSubject();
  Stream<String?> get newPinStream => _newPinSubject.stream;

  late final Stream<bool> isValid = Rx.combineLatest([newPinStream], (values) {
    return _isNewPinValid(displayError: false);
  }).asBroadcastStream();

  Stream<Resource<OTP?>> triggerOtp() {
    return _delegate.triggerOtpForPinReset();
  }

  Stream<Resource<ResetOtpValidationResponse>> validateOtp(String otp) async* {
    final stream = _delegate.validateOtpForPinReset(otp);
    await for(final event in stream) {
      if(event is Success) {
        _otpValidationKey = event.data?.otpValidationKey ?? "";
      }
      yield event;
    }
  }

  Stream<Resource<ResetPINResponse?>> resetPin() => _delegate.resetPin(
      _newPinSubject.value ?? "",
      livelinessValidationKey
  );

  void onPinChanged(String? pin) {
    _newPinSubject.sink.add(pin ?? "");
    _isNewPinValid(displayError: true);
  }

  bool _isNewPinValid({bool displayError = false}) {
    return _newPinSubject.hasValue && _newPinSubject.value?.length == 4;
  }


  @override
  void dispose() {
    _newPinSubject.close();
    super.dispose();
  }
}