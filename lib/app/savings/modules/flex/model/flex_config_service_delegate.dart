
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving_config.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/flex_config_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/flex_saving_config_request_body.dart';

class FlexConfigServiceDelegate with NetworkResource {

  late final FlexConfigService _service;

  FlexConfigServiceDelegate(FlexConfigService service) {
    this._service = service;
  }

  Stream<Resource<FlexSavingConfig>> createFlexConfig(FlexSavingConfigRequestBody request) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.createCustomerFlexConfig(request)
    );
  }

}