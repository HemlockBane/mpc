import 'dart:io';

import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_compare_response.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_criteria.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'liveliness_service.dart';


class LivelinessServiceDelegate with NetworkResource{
  late final LivelinessService _service;

  LivelinessServiceDelegate(LivelinessService service) {
    this._service = service;
  }

  Stream<Resource<LivelinessChecks>> getLivelinessChecks() {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.getLivelinessChecks()
    );
  }

  Stream<Resource<LivelinessCompareResponse>> compareAndGetImageReference(String path, String bvn) {
    return networkBoundResource(
        fetchFromLocal: () => Future.value(null),
        fetchFromRemote: () => this._service.compareAndGetImageReference(File(path), bvn)
    );
  }
}