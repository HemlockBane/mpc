import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/ExistingAccountOTP.dart';
import 'package:moniepoint_flutter/app/onboarding/model/NewAccountOTP.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_form.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_key.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_otp_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/onboarding/model/profile_form.dart';
import 'package:moniepoint_flutter/app/onboarding/username_validation_state.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/security_question_delegate.dart';
import 'package:moniepoint_flutter/core/device_manager.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/models/security_answer.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';


/// @author Paul Okeke
class OnBoardingViewModel extends ChangeNotifier {

  final accountForm = AccountForm();
  final profileForm = ProfileForm();

  BVNValidationRequest? _bvnValidationRequest;

  late OnBoardingServiceDelegate _delegate;
  late SecurityQuestionDelegate _questionDelegate;
  DeviceManager? _deviceManager;

  final List<SecurityQuestion> _securityQuestions = [];

  TransferBeneficiary? _transferBeneficiary;
  TransferBeneficiary? get transferBeneficiary => _transferBeneficiary;
  List<SecurityQuestion> get questions => _securityQuestions;

  String? selfieImageUUID;
  String? signatureImageUUID;

  OTP? _accountOtp;

  bool _isNewAccount = false;
  bool get isNewAccount => _isNewAccount;

  OnBoardingViewModel({
    OnBoardingServiceDelegate? delegate,
    SecurityQuestionDelegate? questionDelegate,
    DeviceManager? deviceManager}) {
    this._delegate = delegate ?? GetIt.I<OnBoardingServiceDelegate>();
    this._questionDelegate = questionDelegate ?? GetIt.I<SecurityQuestionDelegate>();
    this._deviceManager = deviceManager ?? GetIt.I<DeviceManager>();
  }

  void setIsNewAccount(bool isNewAccount) {
    this._isNewAccount = isNewAccount;
    profileForm.setRequestBody(accountForm.account);
  }

  Stream<Resource<OTP>> requestForExistingAccountOtp() {
    final request = AccountInfoRequestBody()
      ..accountNumber = transferBeneficiary?.accountNumber;
    return ExistingAccountOTP(this._delegate, request).responseStream.map((event) {
      if(event is Success) _accountOtp = event.data;
      return event;
    });
  }

  Stream<Resource<ValidationKey>> validateAccountOtp(String? otp) {
    final request = ValidateOtpRequestBody()
      ..accountNumber = transferBeneficiary?.accountNumber
      ..userCode = _accountOtp?.response?.userCode
      ..otp = otp;

    return _delegate.validateAccountOTP(request).map((event) {
      if(event is Success) {
        profileForm.profile.onboardingKey = event.data?.onboardingKey;
      }
      return event;
    });
  }


  Stream<Resource<BVNOTPResult>> requestOtpForNewAccount() {
    final request = BVNOTPValidationRequest()
      ..bvn = accountForm.account.bvn
      ..phoneNumber = accountForm.account.phoneNumber
      ..dob = accountForm.account.dateOfBirth;

    return NewAccountOTP(this._delegate, request).responseStream.map((event) {
      return event;
    });
  }

  Stream<Resource<BVNOTPValidationResult>> validateBVNOTP(String? otp) {
    final request = BVNOTPValidationRequest()
      ..bvn = accountForm.account.bvn
      ..phoneNumber = accountForm.account.phoneNumber
      ..dob = accountForm.account.dateOfBirth
      ..otp = otp;

    return _delegate.validateBVNOTP(request).map((event) {
      if(event is Success) {
        accountForm.account.onboardingKey = event.data?.onBoardingKey;
      }
      return event;
    });
  }

  Stream<Resource<BVNValidationRequest?>> validateBVN() {
    this._bvnValidationRequest = BVNValidationRequest()
      ..gender = accountForm.account.gender
      ..emailAddress = accountForm.account.emailAddress
      ..phoneNumber = accountForm.account.phoneNumber
      ..dob = accountForm.account.dateOfBirth
      ..bvn = accountForm.account.bvn;

    return _delegate.validateBVN(_bvnValidationRequest!).map((event) {
      final data = event.data;
      if (event is Success && data != null) {
        accountForm.account
            ..firstName = data.firstName
            ..surname = data.lastName
            ..otherName = data.middleName;
      }
      return event;
    });
  }

  Stream<Resource<TransferBeneficiary?>> getAccount(AccountInfoRequestBody requestBody) {
    return _delegate.getAccount(requestBody).map((event) {
      if(event is Success) this._transferBeneficiary = event.data;
      return event;
    });
  }

  Stream<Resource<List<SecurityQuestion>>> getSecurityQuestions() {
    if(_securityQuestions.isNotEmpty) return Stream.fromIterable([Resource.success(_securityQuestions)]);
    return _questionDelegate.getAllQuestions().map((event) {
      if(event is Success) {
        _securityQuestions.addAll(event.data ?? []);
        profileForm.initializeSecurityQuestions(_securityQuestions);
      }
      return event;
    });
  }

  List<SecurityAnswer> getSecurityQuestionAnswers() {
    return [
      SecurityAnswer(profileForm.securityQuestionOne?.id.toString(),  profileForm.answerOne),
      SecurityAnswer(profileForm.securityQuestionTwo?.id.toString(),  profileForm.answerTwo),
      SecurityAnswer(profileForm.securityQuestionThree?.id.toString(),  profileForm.answerThree),
    ];
  }

  Stream<Resource<bool>> createUser() {
    profileForm.profile
      ..accountNumber = transferBeneficiary?.accountNumber
      ..deviceId = _deviceManager?.deviceId
      ..deviceName = _deviceManager?.deviceName
      ..securityAnwsers = getSecurityQuestionAnswers();
    return _delegate.createUser(profileForm.profile);
  }

  //TODO don't repeat yourself
  Stream<Resource<AccountProfile>> createAccount() {
    accountForm.account
      ..withSelfieUUID(selfieImageUUID ?? "")
      ..withSignatureUUID(signatureImageUUID ?? "")
      ..withTransactionPin(accountForm.account.pin ?? "")
      ..deviceId = _deviceManager?.deviceId
      ..deviceName = _deviceManager?.deviceName
      ..securityAnwsers = getSecurityQuestionAnswers();
    return _delegate.createAccount(accountForm.account);
  }

  Stream<Resource<FileUUID>> uploadSelfieImage(String filePath) {
    return _delegate.uploadFileForUUID(filePath).map((event) {
      if(event is Success) selfieImageUUID = event.data?.uuid;
      return event;
    });
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
}