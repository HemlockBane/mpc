import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/transfer_beneficiary.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_info_request.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

/// Screen that request for the customer account number before
/// proceeding with the account on-boarding.
/// @author Paul Okeke
class EnterAccountNumberScreen extends StatefulWidget {
  /// We are simply using this key to reference our parent context
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  EnterAccountNumberScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _EnterAccountNumberState(_scaffoldKey);
  }
}

class _EnterAccountNumberState extends State<EnterAccountNumberScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  _EnterAccountNumberState(this._scaffoldKey);

  bool isAccountNumberValid = false;
  bool isLoading = false;

  final TextEditingController mAccountNumberController = TextEditingController();

  void _onAccountNumberChanged() {
    final mAccountNumber = mAccountNumberController.text;
    setState(() {
      isAccountNumberValid = mAccountNumber.length >= 10;
    });
  }

  @override
  void initState() {
    mAccountNumberController.addListener(_onAccountNumberChanged);
    super.initState();
  }

  @override
  void dispose() {
    mAccountNumberController.dispose();
    super.dispose();
  }

  void _onVerifyAccount(Resource<TransferBeneficiary?> event) {
    if (event is Loading) setState(() => isLoading = true);
    if (event is Error<TransferBeneficiary>) {
      setState(() => isLoading = false);
      showModalBottomSheet(
          context: _scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: event.message);
          });
    }
    if(event is Success<TransferBeneficiary>) {
      setState(() => isLoading = false);
      Navigator.of(context).pushNamed('confirm-account');
    }
  }

  void verifyAccount(BuildContext context) {
    var requestBody = AccountInfoRequestBody(
        accountNumber: this.mAccountNumberController.text
    );
    Provider.of<OnBoardingViewModel>(context, listen: false)
        .getAccount(requestBody)
        .listen(_onVerifyAccount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.backgroundWhite,
        padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Sign Up to Moniepoint',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.darkBlue,
                    fontSize: 21,
                ),
              textAlign: TextAlign.start,
            ),
            Text('Enter your account number to get started.',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.textColorBlack,
                    fontSize: 14)
            ),
            SizedBox(height: 30),
            Styles.appEditText(
                hint: 'Account Number',
                inputType: TextInputType.number,
                inputFormats: [FilteringTextInputFormatter.digitsOnly],
                animateHint: true,
                startIcon: Icon(CustomFont.bankIcon, color: Colors.colorFaded),
                drawablePadding: 4,
                maxLength: 10,
                controller: mAccountNumberController
            ),
            Spacer(),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      onClick: isAccountNumberValid && !isLoading ? ()=> verifyAccount(context) : null,
                      text: 'Continue'
                  ),
                ),
                Positioned(
                    right: 16,
                    top: 16,
                    bottom: 16,
                    child: isLoading ? SpinKitThreeBounce(size: 20.0, color: Colors.white) : SizedBox()
                )
              ],
            ),
            SizedBox(height: 32),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: 'Already have a profile? ',
                    style: TextStyle(fontFamily: Styles.defaultFont, fontSize: 15, color: Colors.textColorBlack),
                    children: [
                      TextSpan(
                          text: 'Login',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.primaryColor),
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(_scaffoldKey.currentContext!).popAndPushNamed('/login')
                      )
                    ]
                )
            ),
            SizedBox(height: 24),
          ],
        ),
      );
  }

}