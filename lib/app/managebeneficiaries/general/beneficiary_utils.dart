import 'dart:math';

import '../beneficiary.dart';

class BeneficiaryUtils {
  static List<T> sortByFrequentlyUsed<T extends Beneficiary>(List<T>? list) {
    if (list == null) return [];
    list.sort((a, b) {
      final aElapsedDate = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(a.getLastUpdated() ?? 0)).inDays;
      final bElapsedDate = DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(b.getLastUpdated() ?? 0)).inDays;
      final double aFrequency = pow(a.getFrequency() * (1 - 0.1), aElapsedDate).toDouble();
      final double bFrequency = pow(b.getFrequency() * (1 - 0.1), bElapsedDate).toDouble();
      try {
        return (aFrequency - bFrequency).toInt();
      }catch(e) {
        return 0;
      }
    });
    return list;
  }
}