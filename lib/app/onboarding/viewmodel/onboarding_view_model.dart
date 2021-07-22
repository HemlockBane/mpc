import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/drop_items.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device_request_body.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_form.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/onboarding/model/profile_form.dart';
import 'package:moniepoint_flutter/app/onboarding/username_validation_state.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/customer_validation_service_delegate.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_phone_otp_response.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/models/services/location_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';


/// @author Paul Okeke
class OnBoardingViewModel extends ChangeNotifier {

  final accountForm = AccountForm();
  final profileForm = ProfileForm();

  late OnBoardingServiceDelegate _delegate;
  late CustomerValidationServiceDelegate _customerValidationDelegate;
  late final LocationServiceDelegate _locationServiceDelegate;
  late DeviceManager _deviceManager;

  final List<SecurityQuestion> _securityQuestions = [];
  final List<Nationality> nationalities = [];

  TransferBeneficiary? _transferBeneficiary;
  TransferBeneficiary? get transferBeneficiary => _transferBeneficiary;
  List<SecurityQuestion> get questions => _securityQuestions;

  String? selfieImageUUID;
  String? signatureImageUUID;

  String? _phoneNumberValidationKey;
  String? get phoneNumberValidationKey => _phoneNumberValidationKey;

  OnBoardingType _onBoardingType = OnBoardingType.ACCOUNT_DOES_NOT_EXIST;
  OnBoardingType get onBoardingType => _onBoardingType;

  OnBoardingViewModel({
    OnBoardingServiceDelegate? delegate,
    CustomerValidationServiceDelegate? customerValidationDelegate,
    LocationServiceDelegate? locationServiceDelegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<OnBoardingServiceDelegate>();
    this._customerValidationDelegate = customerValidationDelegate ?? GetIt.I<CustomerValidationServiceDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
    this._locationServiceDelegate = locationServiceDelegate ?? GetIt.I<LocationServiceDelegate>();

    profileForm.setRequestBody(accountForm.account);
  }

  Stream<Resource<bool>> sendOtpToDevice() {
    final phoneNumber = accountForm.account.phoneNumber ?? "";
    final deviceRequest = UserDeviceRequestBody(username: "")
      ..deviceId = _deviceManager.deviceId
      ..deviceName = _deviceManager.deviceName
      ..deviceOs = _deviceManager.deviceOs;

    return _customerValidationDelegate.sendOtpToPhoneNumber(phoneNumber, deviceRequest).map((event) {
          if(event is Success) return Resource.success(true);
          if(event is Error) return Resource<bool>.error(err: ServiceError(message: event.message ?? ""));
          else return Resource.loading(null);
    });
  }

  Stream<Resource<ValidatePhoneOtpResponse>> validateOtpForPhoneNumber(String otp) {
    final phoneNumber = accountForm.account.phoneNumber ?? "";
    final deviceRequest = UserDeviceRequestBody(username: "")
      ..deviceId = _deviceManager.deviceId
      ..deviceName = _deviceManager.deviceName
      ..deviceOs = _deviceManager.deviceOs;

    return _customerValidationDelegate.validateOtpForPhoneNumber(otp, phoneNumber, deviceRequest).map((event) {
        if(event is Success) {
          _phoneNumberValidationKey = event.data?.phoneNumberValidationKey;
        }
        return event;
    });
  }


  Stream<Resource<List<Nationality>>> fetchCountries() {
    return _locationServiceDelegate.getCountries().map((event) {
      if(event is Success || event is Loading) {
        if(nationalities.isNotEmpty) return event;
        nationalities.clear();
        nationalities.addAll(event.data ?? []);
        if(nationalities.isNotEmpty) {
          accountForm.setStates(nationalities.first.states ?? []);
        }
        notifyListeners();
      }
      return event;
    });
  }

  Stream<Resource<AccountProfile>> createAccount(String signaturePath) async* {
    accountForm.account
      ..withTransactionPin(accountForm.account.pin ?? "")
      ..withSetupType(SetupType(type: onBoardingType));

    final uploadSignature = _delegate.uploadFileForUUID(signaturePath);

    await for(var resource in uploadSignature) {
      if(resource is Success) yield* _delegate.createAccount(accountForm.account.withSignatureUUID(resource.data?.uuid ?? ""));
      else if(resource is Loading) yield Resource.loading(null);
      else if(resource is Error<FileUUID>) yield Resource.error(err: ServiceError(message: resource.message ?? ""));
    }
  }

  Stream<Resource<FileUUID>> uploadSignature(String filePath) {
    return _delegate.uploadFileForUUID(filePath).map((event) {
      if(event is Success) signatureImageUUID = event.data?.uuid;
      return event;
    });
  }

  Stream<Resource<bool>> checkUsername(String username) {
    return _delegate.checkUsername(username).map((event) {
      if(event is Success) {
        if(event.data!) {
          profileForm.updateUsernameValidationState(
              UsernameValidationState(
                  UsernameValidationStatus.AVAILABLE, "$username is available")
          );
        }else {
          profileForm.updateUsernameValidationState(
              UsernameValidationState(
                  UsernameValidationStatus.ALREADY_TAKEN, "Username is already taken")
          );
        }
      }
      else if(event is Loading) {
        profileForm.updateUsernameValidationState(
            UsernameValidationState(
                UsernameValidationStatus.VALIDATING, "")
        );
      }
      else if(event is Error<bool>) {
        profileForm.updateUsernameValidationState(
            UsernameValidationState(
                UsernameValidationStatus.FAILED, "An error occurred validating username.")
        );
      }
      return event;
    });
  }

  void setOnBoardingType(OnBoardingType type) {
    this._onBoardingType = type;
    profileForm.setOnboardingType(type);
  }

  void setOnboardingKey(String onboardingKey) {
    this.accountForm.account.onboardingKey = onboardingKey;
  }
}