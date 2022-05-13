import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/app/settings/dialogs/reset_pin_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/reset_pin_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:provider/provider.dart';

import '../../../core/colors.dart';
import '../../../core/network/resource.dart';
import '../../../core/styles.dart';
import '../../../core/utils/dialog_util.dart';
import '../../../core/views/pin_entry.dart';
import '../../../core/views/scroll_view.dart';
import '../../onboarding/model/data/otp.dart';
import '../../usermanagement/model/data/reset_otp_validation_response.dart';
import '../../usermanagement/viewmodels/reset_pin_view_model.dart';


class ResetPinOtpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ResetPinOtpScreenState();
}

class _ResetPinOtpScreenState extends State<ResetPinOtpScreen> {

  late final TextEditingController _otpController;
  late final ResetPinViewModel _viewModel;

  late Stream<Resource<OTP?>> _requestOtpStream;

  bool _isLoading = false;
  bool _isOtpValid = false;

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
    _viewModel = Provider.of<ResetPinViewModel>(context, listen: false);
    _requestOtpStream = _viewModel.triggerOtp();
    _otpController = TextEditingController();
    super.initState();
  }

  void _subscribeUiToOtpValidation(BuildContext context) {
    _viewModel.validateOtp(_otpController.text).listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<ResetOtpValidationResponse>) {
        setState(() => _isLoading = false);
        showError(
            context,
            title: "OTP Validation Failed!",
            message: event.message
        );
      }
      if(event is Success<ResetOtpValidationResponse>) {
        setState(() => _isLoading = false);
        _subscribeToLiveliness();
      }
    });
  }

  void _subscribeToLiveliness() async {
    final validationResponse = await Navigator.of(context)
        .pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": LivelinessVerificationFor.PIN_RESET,
      "otpValidationKey": _viewModel.otpValidationKey
    });

    if (null != validationResponse &&
        validationResponse is ResetPinLivelinessValidationResponse) {
      final validationKey = validationResponse.livelinessValidationKey;

      if (null != validationKey && validationKey.isNotEmpty) {
        _viewModel.livelinessValidationKey = validationKey;
        final pageRoute = MaterialPageRoute(
            builder: (ctx) => ChangeNotifierProvider.value(
                  value: _viewModel,
                  child: ResetPinScreen(),
                )
        );
        Navigator.of(context).push(pageRoute);
      }
    }
  }

  String getUSSD() {
    return "*5573*80#";
  }

  Widget mainBody(BuildContext context) {
    return ScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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
                      'Validate OTP',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 12),
                    Text(
                        'We’ve just sent a 6-digit code to your registered phone number. Enter the code to proceed.',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack,
                            fontSize: 14
                        )
                    ),
                    SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: PinEntry(onChange: (v) {
                        _otpController.text = v;
                        _onOtpChanged();
                      }, numEntries: 6),
                    ),
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
            Row(
              children: [
                Styles.appButton(
                    elevation: 0,
                    onClick: () => Navigator.of(context).pop(),
                    text: "Back",
                    buttonStyle: Styles.lightGreyButtonStyle
                ),
                SizedBox(width: 13),
                Expanded(
                    child: Styles.statefulButton2(
                        elevation: 0,
                        onClick: () => _subscribeUiToOtpValidation(context),
                        text: 'Next',
                        isLoading: _isLoading,
                        isValid:  _isOtpValid && !_isLoading
                    )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  reload() {
    setState(() {
      _requestOtpStream = _viewModel.triggerOtp();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _requestOtpStream,
          builder: (ctx, AsyncSnapshot<Resource<OTP?>> snapshot) {
            if (snapshot.data is Loading) {
              return Center(
                child: CircularProgressIndicator.adaptive()
              );
            }
            if (snapshot.data is Success) {
              return mainBody(context);
            }
            return ErrorLayoutView(
                "Oops!", "Failed to send otp to your device!", reload);
          }),
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }
}