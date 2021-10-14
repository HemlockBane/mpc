import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/work/work_dispatcher.dart';
import 'package:moniepoint_flutter/core/work/worker.dart';

///@author Paul Okeke

class IosBackgroundTaskWorker extends Worker {

  static const IOS_QUEUE_KEY = "IOS_BACKGROUND_TASK_QUEUE";

  @override
  Future<bool> execute(Map<String, dynamic>? inputData) async {
    //Get the pending taskName and run
    final pendingTask = _getAllPendingTask();
    bool shouldRetry = false;

    for(var i = 0; i < pendingTask.length; i++) {
      final taskName = pendingTask[i];
      final worker = getWorker(taskName);
      if(worker == null) continue;

      //TODO we need to be able to serialize/deserialize the actual data for each task
      final result = await worker.execute(inputData).catchError((e) {
        _removeTaskFromQueue(taskName);
      });

      if(result) _removeTaskFromQueue(taskName);
      else shouldRetry = true;
    }
    print("PendingTask <<====>>> $pendingTask");
    return Future.value(shouldRetry == false);
  }

  static void addTaskToQueue(String taskName) {
    final value = PreferenceUtil.getValue(IOS_QUEUE_KEY) as String?;
    final pendingTask = value?.split(",").toSet() ?? {};
    pendingTask.add(taskName);
    PreferenceUtil.saveValue(IOS_QUEUE_KEY, pendingTask.join(","));
    print("Added Task => $taskName to Queue");
    print("Task that are pending are ${_getAllPendingTask()}");
  }

  static void _removeTaskFromQueue(String taskName) {
    final value = PreferenceUtil.getValue(IOS_QUEUE_KEY) as String?;
    final pendingTask = value?.split(",") ?? [];
    pendingTask.remove(taskName);
    PreferenceUtil.saveValue(IOS_QUEUE_KEY, pendingTask.join(","));
  }

  static List<String> _getAllPendingTask () {
    final value = PreferenceUtil.getValue(IOS_QUEUE_KEY) as String?;
    print("All Pending Task => $value");
    return value?.split(",") ?? [];
  }

}

