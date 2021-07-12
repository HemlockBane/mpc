import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'new_account_view.dart';

class VerifyPhoneNumberOTPScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  VerifyPhoneNumberOTPScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _VerifyPhoneNumberOTPScreen(_scaffoldKey);
  }

}

class _VerifyPhoneNumberOTPScreen extends State<VerifyPhoneNumberOTPScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  late final TextEditingController otpController;

  bool _isLoading = false;
  bool _isOtpValid = false;

  _VerifyPhoneNumberOTPScreen(this._scaffoldKey);

  void _onOtpChanged() {
    final text = otpController.text;
      setState(() {
        _isOtpValid = text.isNotEmpty && text.length >= 6;
      });
  }

  @override
  void initState() {
    otpController = TextEditingController()..addListener(_onOtpChanged);

    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    //   viewModel.requestOtpForNewAccount().listen((event) {
    //     print(event);
    //   });
    // });
  }

  void _subscribeUiToOtpValidation(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    Navigator.of(context).pushNamed(NewAccountScreen.COLLECTION_SCREEN);

    // viewModel.validateBVNOTP(otpController.text).listen((event) {
    //   if(event is Loading) setState(() => _isLoading = true);
    //   if (event is Error<BVNOTPValidationResult>) {
    //     setState(() => _isLoading = false);
    //     showModalBottomSheet(
    //         context: _scaffoldKey.currentContext ?? context,
    //         isScrollControlled: true,
    //         backgroundColor: Colors.transparent,
    //         builder: (context) {
    //           return BottomSheets.displayErrorModal(context, message: event.message);
    //         });
    //   }
    //   if(event is Success<BVNOTPValidationResult>) {
    //     setState(() => _isLoading = false);
    //     Navigator.of(context).pushNamed(NewAccountScreen.COLLECTION_SCREEN);
    //   }
    // });
  }

  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {
    return ScrollView(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
        color: Colors.backgroundWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify Phone Number',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.colorPrimaryDark,
                fontSize: 24,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 6),
            Text(
                'We’ve just sent a 6-digit code to your registered phone number. Enter the code to proceed.',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.textColorBlack,
                    fontSize: 14)),
            SizedBox(height: 30),
            Styles.appEditText(
                hint: 'Enter 6-Digit Code',
                animateHint: true,
                inputType: TextInputType.number,
                inputFormats: [FilteringTextInputFormatter.digitsOnly],
                startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                drawablePadding: EdgeInsets.only(left: 4, right: 4),
                controller: otpController,
                maxLength: 6),
            SizedBox(height: 20),
            OtpUssdInfoView("Onboarding Phone Number Validation OTP Mobile", defaultCode: "*5573*70#",),
            Spacer(),
            SizedBox(height: 20),
            Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      onClick: _isOtpValid && !_isLoading
                          ? () => _subscribeUiToOtpValidation(context)
                          : null,
                      text: 'Continue'),
                ),
                Positioned(
                    right: 16,
                    top: 16,
                    bottom: 16,
                    child: _isLoading
                        ? SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.5))
                        : SizedBox())
              ],
            ),
            SizedBox(
              height: 66,
            )
          ],
        ),
      ),
    );
  }
}