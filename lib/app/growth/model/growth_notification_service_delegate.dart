
import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/notification_status_type.dart';
import 'growth_notification_service.dart';

class GrowthNotificationServiceDelegate with NetworkResource{

  late final GrowthNotificationService _service;

  GrowthNotificationServiceDelegate(GrowthNotificationService service) {
    this._service = service;
  }

  Stream<Resource<dynamic>> updateNotificationStatus(int notificationId, NotificationStatusType statusType) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => this._service.updateNotificationAction(notificationId, describeEnum(statusType))
    );
  }

}