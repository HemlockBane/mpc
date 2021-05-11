import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/dialogs/ussd_pin_dialog.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

class USSDView extends StatefulWidget{

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final VoidCallback? onCompleted;

  USSDView(this._scaffoldKey, {this.onCompleted});

  @override
  State<StatefulWidget> createState() {
    return _USSDView();
  }

}

class _USSDView extends State<USSDView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    void _displayUssdPinDialog() {
      showModalBottomSheet(
          isScrollControlled: false,
          context: widget._scaffoldKey.currentContext ?? context,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return UssdPinDialog((pin) {
              Navigator.pop(context);
              viewModel.accountForm.account
                  .withCreateUSSDPin(true)
                ..withUSSDPin(pin);
              widget.onCompleted?.call();
            });
          });
    }

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle
            ),
            child: SvgPicture.asset('res/drawables/ic_ussd_symbol.svg'),
          ),
          SizedBox(height: 21),
          Text(
            'Do you want to activate USSD Mobile Banking on this phone number ?',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(viewModel.accountForm.account.phoneNumber ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.primaryColor)),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Styles.appButton(onClick: () {
                widget.onCompleted?.call();
              }, text: 'NO', elevation: 0, buttonStyle: Styles.redButtonStyle)),
              SizedBox(width: 32,),
              Expanded(child: Styles.appButton(onClick: _displayUssdPinDialog, text: 'YES', elevation: 0)),
            ],
          ),
          SizedBox(height: 54)
        ],
      ),
    );
  }

}