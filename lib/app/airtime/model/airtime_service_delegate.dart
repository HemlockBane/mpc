
import 'package:moniepoint_flutter/app/airtime/model/airtime_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';

class AirtimeServiceDelegate with NetworkResource {
  late final AirtimeService _service;

  AirtimeServiceDelegate(AirtimeService service) {
    this._service = service;
  }

}