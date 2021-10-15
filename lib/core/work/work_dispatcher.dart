
import 'package:moniepoint_flutter/app/notifications/model/device_token_registration_worker.dart';
import 'package:moniepoint_flutter/app/notifications/model/notification_service.dart';
import 'package:moniepoint_flutter/app/notifications/model/notification_service_delegate.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/ios_background_task_worker.dart';
import 'package:moniepoint_flutter/core/work/worker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

///@author Paul Okeke
///

late final Map<String, Worker> _workers;

Worker? getWorker(String key) {
  print("Key ==> $key ===> $_workers");
  return _workers[key];
}

void registerWorkers() {
  _workers = {
    Workmanager.iOSBackgroundTask: IosBackgroundTaskWorker(),
    DeviceTokenRegistrationWorker.WORKER_KEY: DeviceTokenRegistrationWorker(
      delegate: NotificationServiceDelegate(NotificationService(ServiceModule.getConfiguredApiClient()))
    ),
  };
}

void workDispatcher () {
  registerWorkers();
  Workmanager().executeTask((taskName, inputData) async {
    return true;
    await PreferenceUtil.reload();
    final worker = getWorker(taskName);
    if(worker == null) return true;
    return await worker.execute(inputData);
  });
}
