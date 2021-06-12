
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';

class RemoveBeneficiaryPinDialog extends StatefulWidget {

  RemoveBeneficiaryPinDialog();

  @override
  State<StatefulWidget> createState() => _RemoveBeneficiaryPinDialog();

}

class _RemoveBeneficiaryPinDialog extends State<RemoveBeneficiaryPinDialog> {

  String _pin = "";

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
        content: Wrap(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 22),
                  Center(
                    child: Text('Confirm Removal',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.colorPrimaryDark)),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('Enter Transaction PIN',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.colorPrimaryDark,
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
                    child: PinEntry(onChange: (value) {
                      setState(() {
                        _pin = value;
                      });
                    }),
                  ),
                  SizedBox(height: 47),
                  Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      width: double.infinity,
                      child: Styles.statefulButton2(
                          elevation: _pin.isNotEmpty && _pin.length >= 4 ? 0.5 : 0,
                          isValid: _pin.isNotEmpty && _pin.length >= 4,
                          onClick: () => Navigator.of(context).pop(_pin),
                          text: 'Continue')),
                  SizedBox(height: 42)
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

}
