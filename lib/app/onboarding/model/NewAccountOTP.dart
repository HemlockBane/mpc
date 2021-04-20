import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/base_otp.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class NewAccountOTP extends BaseOtp<BVNOTPValidationRequest, Resource<BVNOTPResult>> {
  final OnBoardingServiceDelegate _delegate;
  BVNOTPValidationRequest _otpRequest;

  NewAccountOTP(this._delegate, this._otpRequest)
      : super(key: 'new_account_otp', data: _otpRequest, retryTime: 12000);

  @override
  Stream<Resource<BVNOTPResult>> call() {
    return this._delegate.requestForBvnOtp(this._otpRequest);
  }
}