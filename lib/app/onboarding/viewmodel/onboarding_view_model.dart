import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service_delegate.dart';
import 'package:moniepoint_flutter/app/onboarding/model/profile_form.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

/// @author Paul Okeke
class OnBoardingViewModel extends ChangeNotifier {

  final profileForm = ProfileForm();

  late OnBoardingServiceDelegate _delegate;

  TransferBeneficiary? _transferBeneficiary;

  TransferBeneficiary? get transferBeneficiary => _transferBeneficiary;

  OnBoardingViewModel({OnBoardingServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<OnBoardingServiceDelegate>();
  }

  Stream<Resource<TransferBeneficiary?>> getAccount(AccountInfoRequestBody requestBody) {
    return _delegate.getAccount(requestBody).map((event) {
      if(event is Success) this._transferBeneficiary = event.data;
      return event;
    });
  }

}