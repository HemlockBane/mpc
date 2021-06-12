import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_otp_validation_result.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/validation_key.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:provider/provider.dart';


class ExistingAccountOTPScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  ExistingAccountOTPScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _ExistingAccountOTPScreen(_scaffoldKey);
  }

}

class _ExistingAccountOTPScreen extends State<ExistingAccountOTPScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  late final TextEditingController otpController;

  bool _isLoading = false;
  bool _isOtpValid = false;

  _ExistingAccountOTPScreen(this._scaffoldKey);

  void _onOtpChanged() {
    final text = otpController.text;
    setState(() {
      _isOtpValid = text.isNotEmpty && text.length >= 6;
    });
  }

  @override
  void initState() {
    otpController = TextEditingController()
      ..addListener(_onOtpChanged);

    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
      viewModel.requestForExistingAccountOtp().listen((event) {
        print(event);
      });
    });
  }

  void _subscribeUiToOtpValidation(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    viewModel.validateAccountOtp(otpController.text).listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<ValidationKey>) {
        setState(() => _isLoading = false);
        showModalBottomSheet(
            context: _scaffoldKey.currentContext ?? context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
      if(event is Success<ValidationKey>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed("profile");
      }
    });
  }

  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {
    final ussd = getUSSD();
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
        color: Colors.backgroundWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter 6-Digit Code',
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
                startIcon: Icon(CustomFont.bankIcon, color: Colors.colorFaded),
                drawablePadding: EdgeInsets.only(left: 4, right: 4),
                controller: otpController,
                maxLength: 6),
            SizedBox(height: 20),
            OtpUssdInfoView("Onboarding Phone Number Validation OTP Mobile"),
            Spacer(),
            Styles.statefulButton2(
                onClick: () => _subscribeUiToOtpValidation(context),
                text: "Continue",
                isValid: _isOtpValid,
                isLoading: _isLoading
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