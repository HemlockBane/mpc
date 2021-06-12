import 'dart:convert';
import 'dart:io';

import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_compare_response.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/liveliness_criteria.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'liveliness_service.dart';


class LivelinessServiceDelegate with NetworkResource{
  late final LivelinessService _service;

  LivelinessServiceDelegate(LivelinessService service) {
    this._service = service;
  }

  Stream<Resource<LivelinessChecks>> getLivelinessChecks() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          final livelinessConfigString = PreferenceUtil.getValue(PreferenceUtil.LIVELINESS_CONFIG);
          print(livelinessConfigString);
          if(livelinessConfigString == null) return Stream.value(null);
          final decoded = jsonDecode(livelinessConfigString);
          return Stream.value(LivelinessChecks.fromJson(decoded));
        },
        fetchFromRemote: () => this._service.getLivelinessChecks(),
        saveRemoteData: (data)  async {
          PreferenceUtil.saveValue(PreferenceUtil.LIVELINESS_CONFIG, jsonEncode(data));
        }
    );
  }

  Stream<Resource<LivelinessCompareResponse>> compareAndGetImageReference(String path, String bvn) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.compareAndGetImageReference(File(path), bvn)
    );
  }
}