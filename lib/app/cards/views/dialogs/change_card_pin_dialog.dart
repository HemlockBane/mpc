import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_password_view_model.dart';
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_pin_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';

class ChangeCardPinDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangeCardPinDialog();
}

class _ChangeCardPinDialog extends State<ChangeCardPinDialog> {
  bool _isLoading = false;
  String _oldPin = "";
  String _newPin = "";
  String _cvv = "";

  void subscribeUiToChangePin() {
    Navigator.of(context).pop(
        CardTransactionRequest()
          ..oldPin = _oldPin
          ..newPin = _newPin
          ..cvv = _cvv
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_dialog_three_dots.svg',
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 25,
        content: Wrap(children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16,),
                Center(
                  child: Text('Change Card Pin',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.colorPrimaryDark)),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text('Enter Current PIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: PinEntry(onChange: (v) {
                    setState(() {
                      _oldPin = v;
                    });
                  }),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text('Enter New PIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  child: PinEntry(onChange: (v){
                    _newPin = v;
                  }),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text('CVV',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 50, right: 50, bottom: MediaQuery.of(context).viewInsets.bottom * 0.6),
                  child: PinEntry(numEntries :3 ,onChange: (v) {
                    _cvv = v;
                  }),
                ),
                SizedBox(height: 32),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    child: Styles.statefulButton2(
                        elevation: 0.5,
                        isLoading: _isLoading,
                        isValid: _newPin.length >= 4 && _oldPin.length >= 4 && _cvv.length >= 3,
                        onClick: () => subscribeUiToChangePin(),
                        text: 'Change Pin')),
                SizedBox(height: 42)
              ],
            ),
          )
        ])
    );
  }
}
