import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';

class UssdPinDialog extends StatefulWidget {
  final ValueChanged<String> onComplete;

  UssdPinDialog(this.onComplete);

  @override
  State<StatefulWidget> createState() {
    return _UssdPinDialog();
  }
}

class _UssdPinDialog extends State<UssdPinDialog> {
  String pin = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        paddingRight: 16,
        paddingLeft: 16,
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerImageRes: 'res/drawables/ic_dialog_three_dots.svg',
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        content: Wrap(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text('Set USSD Transaction PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.darkBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 22)),
                  SizedBox(height: 12),
                  Text('Please enter your 4-digit transaction PIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.deepGrey, fontSize: 14)),
                  SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('Enter PIN',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50),
                    child: PinEntry(onChange: (value) {
                      setState(() {
                        pin = value;
                      });
                    }),
                  ),
                  SizedBox(height: 47),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0,
                          onClick: pin.isNotEmpty
                              ? () => widget.onComplete.call(pin)
                              : null,
                          text: 'Set PIN')),
                  SizedBox(height: 32)
                ],
              ),
            )
          ],
        ));
  }
}
