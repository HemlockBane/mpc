import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/core/models/base_otp.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/otp.dart';

import 'data/account_info_request.dart';

class ExistingAccountOTP extends BaseOtp<AccountInfoRequestBody, Resource<OTP>> {
  final OnBoardingServiceDelegate _delegate;
  AccountInfoRequestBody _otpRequest;

  ExistingAccountOTP(this._delegate, this._otpRequest)
      : super(key: 'existing_account_otp', data: _otpRequest, retryTime: 12000);

  @override
  Stream<Resource<OTP>> call() {
    return this._delegate.requestForAccountOtp(this._otpRequest);
  }
}