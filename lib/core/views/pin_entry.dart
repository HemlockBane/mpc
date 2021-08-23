import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

/// @author Paul Okeke
class PinEntry extends StatefulWidget {
  late final int numEntries;
  late final ValueChanged<String>? onChange;

  PinEntry({this.numEntries = 4, this.onChange});

  @override
  State<StatefulWidget> createState() {
    return _PinEntryState(numEntries, onChange);
  }
}

class _PinEntryState extends State<PinEntry> {
  final int _numEntries;
  final ValueChanged<String>? onChange;
  var _pin = "";

  _PinEntryState(this._numEntries, this.onChange);

  //We are simply going to create a stack with a container and a text field
  // beneath

  Widget makePinEntryView({Color color = Colors.primaryColor}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.primaryColor.withOpacity(0.1)
      ),
      child: Container(
        width: 11,
        height: 11,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }

  Widget makeLineEntryView() {
    return Padding(
      padding: EdgeInsets.only(left: 8.5, right: 8.5),
      child: SizedBox(width: 1,),
    );
  }

  Widget buildPinBoxes() {
    final List<Widget> children = <Widget>[];
    var color = Colors.primaryColor;

    for (int i = 0; i < this._numEntries; i++) {
      //first we add an indicator
      if (i + 1 > _pin.length) {
        color = Colors.deepGrey.withOpacity(0.4);
      } else {
        color = Colors.primaryColor;
      }

      //check if there's text
      final entryView = makePinEntryView(color: color);
      children.add(entryView);

      if (i < this._numEntries - 1) {
        children.add(makeLineEntryView());
      }
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  void updatePin(String pin) {
    setState(() {
      this._pin = pin;
    });
    if(_pin.length >= _numEntries) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    onChange?.call(pin);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.only(left: 12, right: 12, top: 4.5, bottom: 4.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0XFF0048B7).withOpacity(0.11)),
        color: Colors.white,
      ),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Positioned(
              top: 0, bottom: 0, right: 0, left: 0, child: buildPinBoxes()
          ),
          Positioned(
              child: Opacity(
                  opacity: 0,
                  child: Styles.appEditText(
                      inputFormats: [
                        LengthLimitingTextInputFormatter(_numEntries)
                      ],
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      inputType: TextInputType.number,
                      hint: '',
                      onChanged: updatePin
                  )
              )
          )
        ],
      ),
    );
  }
}
