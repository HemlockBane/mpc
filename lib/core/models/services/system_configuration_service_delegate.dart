import 'dart:convert';

import 'package:moniepoint_flutter/core/models/services/system_configuration_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

import '../system_configuration.dart';

class SystemConfigurationServiceDelegate with NetworkResource{

  late final SystemConfigurationService _service;

  SystemConfigurationServiceDelegate(this._service);

  Stream<Resource<List<SystemConfiguration>>> getSystemConfigurations({bool forceRemote = true}) {
    return networkBoundResource(
        shouldFetchFromRemote: (data) => data?.isEmpty == true || forceRemote,
        shouldFetchLocal: true,
        fetchFromLocal: () {
          String? value = PreferenceUtil.getValue(PreferenceUtil.SYSTEM_CONFIG);
          List<dynamic> configs = (value != null) ? jsonDecode(value) : [];
          return Stream.value(configs.map((e) => SystemConfiguration.fromJson(e)).toList());
        },
        fetchFromRemote: () => _service.getAllSystemConfigs(),
        saveRemoteData: (data) async {
          PreferenceUtil.saveValue(PreferenceUtil.SYSTEM_CONFIG, jsonEncode(data));
        }
    );
  }

}