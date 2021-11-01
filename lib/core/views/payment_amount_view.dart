import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

import '../colors.dart';



const Color currencyColor = Colors.white;

class PaymentAmountView extends StatefulWidget {

  final int _defaultAmount;
  final ValueChanged<num> _valueChanged;
  final bool? isAmountFixed;
  final Color? currencyColor;
  final Color? textColor;
  final double? maxAmount;

  PaymentAmountView(
      this._defaultAmount,
      this._valueChanged, {
        this.isAmountFixed = false, this.currencyColor = Colors.primaryColor, this.textColor = Colors.solidDarkBlue, this.maxAmount});

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
        SvgPicture.asset('res/drawables/ic_naira.svg', width: 21, height: 21, color: (widget.isAmountFixed == true) ? Colors.deepGrey : widget.currencyColor,),
        SizedBox(width: 8),
        Expanded(
            child: TextFormField(
              controller: _controller,
              cursorColor: Colors.darkBlue,
              cursorRadius: Radius.circular(28),
              maxLines: 1,
              textInputAction: TextInputAction.done,
              //On iOS with "TextInputType.number" the done/next option is not displayed
              keyboardType: Platform.isIOS ? TextInputType.text : TextInputType.number,
              enabled: widget.isAmountFixed != true,
              onChanged: (v) => widget._valueChanged.call(int.parse(MoneyInputFormatter.clearCurrencyToNumberString(v))),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                if(widget.maxAmount != null)
                  MaxAmountFormatter(maxAmount: widget.maxAmount!),
                MoneyInputFormatter(),
              ],
              style: TextStyle(
                  fontFamily: Styles.defaultFont,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: (widget.isAmountFixed == true) ? Colors.deepGrey : widget.textColor
              ),
              decoration: InputDecoration(
                  isCollapsed: true,
                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
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