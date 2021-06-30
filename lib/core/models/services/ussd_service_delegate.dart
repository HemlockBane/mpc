import 'dart:convert';

import 'package:moniepoint_flutter/core/models/services/ussd_service.dart';
import 'package:moniepoint_flutter/core/models/ussd_configuration.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';


class USSDServiceDelegate with NetworkResource{

  late final USSDService _service;

  USSDServiceDelegate(this._service);

  Stream<Resource<List<USSDConfiguration>>> getUSSDConfiguration() {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () {
          String? value = PreferenceUtil.getValue(PreferenceUtil.USSD_CONFIG);
          List<dynamic> configs = (value != null) ? jsonDecode(value) : [];
          return Stream.value(configs.map((e) => USSDConfiguration.fromJson(e)).toList());
        },
        fetchFromRemote: () => _service.getUSSDConfigurations(),
        saveRemoteData: (data) async {
          PreferenceUtil.saveValue(PreferenceUtil.USSD_CONFIG, jsonEncode(data));
        }
    );
  }

}