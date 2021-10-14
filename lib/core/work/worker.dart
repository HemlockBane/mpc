
///@author Paul Okeke
abstract class Worker {
  Future<bool> execute(Map<String, dynamic>? inputData);
}