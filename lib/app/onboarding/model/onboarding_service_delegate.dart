import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/model/onboarding_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class OnBoardingServiceDelegate with NetworkResource {
  late final OnBoardingService _service;

  OnBoardingServiceDelegate(OnBoardingService service) {
    this._service = service;
  }

  Stream<Resource<TransferBeneficiary>> getAccount(AccountInfoRequestBody requestBody) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getAccount(requestBody)
    );
  }
}
