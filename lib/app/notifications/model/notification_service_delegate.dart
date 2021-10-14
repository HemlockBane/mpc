import 'package:moniepoint_flutter/app/notifications/model/notification_service.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/register_device_token_request.dart';

class NotificationServiceDelegate with NetworkResource {
  late final NotificationService _service;

  NotificationServiceDelegate(NotificationService service) {
    this._service = service;
  }

  Stream<Resource<bool>> registerDeviceToken(String token) {
    return networkBoundResource(
      fetchFromLocal: () => Stream.value(null),
      fetchFromRemote: () => _service.registerDeviceToken(
          RegisterDeviceTokenRequest(deviceToken: token)
      ),
    );
  }

}