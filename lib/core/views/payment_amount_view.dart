import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

import '../colors.dart';

class PaymentAmountView extends StatefulWidget {

  final int _defaultAmount;
  final ValueChanged<num> _valueChanged;
  final bool? isAmountFixed;

  PaymentAmountView(
      this._defaultAmount,
      this._valueChanged, {this.isAmountFixed = false});

  @override
  State<StatefulWidget> createState() => _PaymentAmountView();

}

class _PaymentAmountView extends State<PaymentAmountView> {

  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  void setDefaultValue() {
    String amount = widget._defaultAmount.toString();
    _controller?.text = MoneyInputFormatter.format(
        TextEditingValue.empty,
        TextEditingValue(text: amount, selection: TextSelection(baseOffset: amount.length, extentOffset: amount.length))
    ).text;
  }

  @override
  Widget build(BuildContext context) {
    setDefaultValue();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('res/drawables/ic_naira.svg', width: 30, height: 30,),
        SizedBox(width: 8),
        Expanded(
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.darkBlue,
              cursorRadius: Radius.circular(28),
              maxLines: 1,
              onChanged: (v) => widget._valueChanged.call(int.parse(MoneyInputFormatter.clearCurrencyToNumberString(v))),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                MoneyInputFormatter()
              ],
              style: TextStyle(
                  fontFamily: Styles.defaultFont,
                  fontSize: 28,
                    fontWeight: FontWeight.bold,
                  color: Colors.solidDarkBlue
              ),
              decoration: InputDecoration(
                  isCollapsed: true,
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent))
              ),
            )
        )
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}