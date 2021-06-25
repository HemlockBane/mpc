import 'dart:io';

import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/account_creation_service.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/profile_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_key.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_otp_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/core/models/file_uuid.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

/// @author Paul Okeke
class OnBoardingServiceDelegate with NetworkResource {
  late final OnBoardingService _service;
  late final AccountCreationService _accountCreationService;

  OnBoardingServiceDelegate(OnBoardingService service, AccountCreationService creationService) {
    this._service = service;
    this._accountCreationService = creationService;
  }

  Stream<Resource<TransferBeneficiary>> getAccount(AccountInfoRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getAccount(requestBody)
    );
  }

  Stream<Resource<BVNValidationRequest>> validateBVN(BVNValidationRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._accountCreationService.validateBVN(requestBody)
    );
  }

  Stream<Resource<BVNOTPResult>> requestForBvnOtp(BVNOTPValidationRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._accountCreationService.requestBVNOTP(requestBody)
    );
  }

  Stream<Resource<BVNOTPValidationResult>> validateBVNOTP(BVNOTPValidationRequest requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._accountCreationService.validateBVNOTP(requestBody)
    );
  }

  Stream<Resource<OTP>> requestForAccountOtp(AccountInfoRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.getOTP(requestBody)
    );
  }

  Stream<Resource<ValidationKey>> validateAccountOTP(ValidateOtpRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.validateOTP(requestBody)
    );
  }

  Stream<Resource<bool>> createUser(ProfileCreationRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.onBoardUser(requestBody)
    );
  }

  Stream<Resource<AccountProfile>> createAccount(AccountCreationRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.createAccount(requestBody)
    );
  }

  Stream<Resource<FileUUID>> uploadFileForUUID(String filePath) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () async {
          return this._accountCreationService.uploadImageForUUID(File(filePath));
        });
  }

  Stream<Resource<bool>> checkUsername(String username) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () async {
          return this._service.checkUsername(username);
        });
  }
}
