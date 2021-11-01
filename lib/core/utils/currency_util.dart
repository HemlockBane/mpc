import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

extension CurrencyUtil on num {
  static final f = new NumberFormat("###,###,###,###,###,###,##0.00", "en_NG");
  static final _f2 = new NumberFormat("#,##0", "en_NG");

  String get formatCurrencyWithoutSymbolAndDividing => f.format(this);

  String get formatCurrency => "₦ ${f.format(this)}";

  String get formatCurrencyWithoutSymbol => "${f.format(this)}";

  String get formatCurrencyWithoutLeadingZero => "₦ ${_f2.format(this)}";
}


class MoneyInputFormatter extends TextInputFormatter {

  static String clearCurrencyToNumberString(String value) {
    return value.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,. )]'), "");
  }

  static String _formatNumberToCurrency(String value) {
    double mValue = double.parse(value);
    return (mValue / 100).formatCurrencyWithoutSymbol;
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
    TextEditingValue newValue) {
    return format(oldValue, newValue);
  }

  static TextEditingValue format(TextEditingValue oldValue,
    TextEditingValue newValue) {
    int lastCursorPosition = -1;

    String cleanString = clearCurrencyToNumberString(newValue.text);
    try {
      String formattedAmount = _formatNumberToCurrency(cleanString);

      if (newValue.selection.start != newValue.text.length) {
        int lengthDelta = max(0, formattedAmount.length - oldValue.text.length);
        int newCursorOffset = max(0,
          min(formattedAmount.length, oldValue.selection.start + lengthDelta));
        lastCursorPosition = newCursorOffset;
      } else {
        lastCursorPosition = formattedAmount.length;
      }

      return newValue.copyWith(
        text: formattedAmount,
        selection: TextSelection.collapsed(offset: lastCursorPosition)
      );
    } catch (e) {
      print(e);
    }
    return newValue;
  }

}


class MaxAmountFormatter extends TextInputFormatter {
  final double maxAmount;

  MaxAmountFormatter({required this.maxAmount});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
    TextEditingValue newValue) {
    var currentAmountString = newValue.text;

    final val = double.tryParse(currentAmountString);
    if (val == null) return newValue;

    //TODO: I have no idea what is happening here. Ask @Paul to explain this multiplying and dividing by 100

    print("val: ${val/1}");
    print("val: ${val/100}");
    print("max amount: $maxAmount");

    if ((val/100) > maxAmount) {
      currentAmountString = (maxAmount * 10).toString();
    }

    return newValue.copyWith(
      text: currentAmountString,
      selection: TextSelection.collapsed(offset: currentAmountString.length),
    );
  }
}