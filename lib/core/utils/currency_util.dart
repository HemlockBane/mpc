import 'package:intl/intl.dart';

extension CurrencyUtil on num {
  static final f = new NumberFormat("#,##0.00", "en_US");
  String get formatCurrencyWithoutSymbolAndDividing => f.format(this);
}