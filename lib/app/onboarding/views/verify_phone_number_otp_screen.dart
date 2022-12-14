import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_phone_otp_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'signup_account_view.dart';

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

  late final TextEditingController _otpController;

  bool _isLoading = false;
  bool _isOtpValid = false;

  _VerifyPhoneNumberOTPScreen(this._scaffoldKey);

  void _onOtpChanged() {
    final text = _otpController.text;
    _isOtpValid = text.isNotEmpty && text.length >= 6;
    if(_isOtpValid) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    setState(() {});
  }

  @override
  void initState() {
    _otpController = TextEditingController();
    super.initState();
  }

  void _subscribeUiToOtpValidation(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    viewModel.validateOtpForPhoneNumber(_otpController.text).listen((event) {
        if(event is Loading) setState(() => _isLoading = true);
        if (event is Error<ValidatePhoneOtpResponse>) {
          setState(() => _isLoading = false);
          showError(
              _scaffoldKey.currentContext ?? context,
              title: "OTP Validation Failed!",
              message: event.message
          );
        }
        if(event is Success<ValidatePhoneOtpResponse>) {
          setState(() => _isLoading = false);
          Navigator.of(context).pushNamed(SignUpAccountScreen.ONBOARDING_ENTER_BVN);
        }
    });
  }

  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height - (70 + bottom),//subtract the vertical padding
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verify Phone Number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 12),
                    Text(
                        'We???ve just sent a 6-digit code to your registered phone number. Enter the code to proceed.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack,
                            fontSize: 14)
                    ),
                    SizedBox(height: 30),
                    Styles.appEditText(
                        hint: 'Enter 6-Digit Code',
                        animateHint: true,
                        inputType: TextInputType.number,
                        inputFormats: [FilteringTextInputFormatter.digitsOnly],
                        startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 24),
                        drawablePadding: EdgeInsets.only(left: 4, right: 4),
                        controller: _otpController,
                        onChanged: (v) => _onOtpChanged(),
                        maxLength: 6),
                    SizedBox(height: 20),
                    OtpUssdInfoView(
                      "Onboarding Phone Number Validation OTP Mobile",
                      defaultCode: "*5573*70#",
                      message: "Didn't get the code? Dial {}",
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Styles.statefulButton2(
                elevation: 0,
                onClick: () => _subscribeUiToOtpValidation(context),
                text: 'Next',
                isLoading: _isLoading,
                isValid:  _isOtpValid && !_isLoading
            ),
          ],
        ),
      ),
    );
  }
}