import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device_request_body.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'customer_validation_service.dart';
import 'data/validate_phone_otp_response.dart';

class CustomerValidationServiceDelegate with NetworkResource {
  late final CustomerValidationService _service;

  CustomerValidationServiceDelegate(CustomerValidationService service) {
    this._service = service;
  }

  Stream<Resource<dynamic>> sendOtpToPhoneNumber(String phoneNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.sendOtpToPhoneNumber(phoneNumber)
    );
  }

  Stream<Resource<ValidatePhoneOtpResponse>> validateOtpForPhoneNumber(String otp, String phoneNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.validateOtpForPhoneNumber(otp, phoneNumber)
    );
  }


}