import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/add_device_dialog.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class RecoveryOtpView extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoveryOtpView(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoveryOtpView();
  }
}

class _RecoveryOtpView extends State<RecoveryOtpView> {

  TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  bool _hasOtp = false;


  @override
  void initState() {
    _otpController.addListener(() {
      String otp = _otpController.text;
      setState(() {
        _hasOtp = otp.isNotEmpty && otp.length == 6;
      });
    });
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _subscribeUiToTriggerOtpForDevice();
    });
    super.initState();
  }

  void _subscribeUiToTriggerOtpForDevice() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    if(viewModel.recoveryMode == RecoveryMode.DEVICE) {
      viewModel.getOtpForDevice().listen((event) => null);
    }
  }

  void _subscribeToValidateOtp() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    RecoveryMode? mode = viewModel.recoveryMode;

    if(mode == RecoveryMode.USERNAME_RECOVERY) {
      viewModel.setOtpCode(_otpController.text);
      viewModel.validateOtp().listen(_handleUsernameRecoveryResponse);
    } else if(mode == RecoveryMode.PASSWORD_RECOVERY){
      viewModel.setOtpCode(_otpController.text);
      //looks like we validate the otp first here
      viewModel.validateOtp().listen(_handleValidateOtpResponse);
    } else if(mode == RecoveryMode.DEVICE) {
      viewModel.validateDeviceOtp(_otpController.text).listen(_handleOtpValidationResponseForDevice);
    }
  }

  void _handleUsernameRecoveryResponse(Resource<RecoveryResponse> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if(event is Success<RecoveryResponse>) {
      setState(() => _isLoading = false);
      _startLivelinessTest(
          LivelinessVerificationFor.USERNAME_RECOVERY,
          event.data!.otpValidationKey!
      );
    }
    if (event is Error<RecoveryResponse>) {
      setState(() => _isLoading = false);
      showModalBottomSheet(
          context: widget._scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: event.message);
          });
    }
  }

  void _startLivelinessTest(LivelinessVerificationFor verificationFor, String validationKey) async {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    final validationResponse = await Navigator.of(widget._scaffoldKey.currentContext ?? context)
        .pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": verificationFor,
      "key" : "",
      "otpValidationKey": validationKey
    });
  }

  String getUSSDKeyName(RecoveryViewModel viewModel) {
    if (viewModel.recoveryMode == RecoveryMode.USERNAME_RECOVERY) {
      return "Forgot Username Phone Number Validation OTP Mobile";
    } else if (viewModel.recoveryMode == RecoveryMode.PASSWORD_RECOVERY) {
      return "Forgot Password Phone Number Validation OTP Mobile";
    } else {
      return "Add Device OTP Mobile";
    }
  }

  void _handleValidateOtpResponse<T>(Resource<T> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if (event is Error<T>) {
      setState(() => _isLoading = false);
      showModalBottomSheet(
          context: widget._scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: event.message);
          });
    }
    if(event is Success<T>) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushNamed('set_password');
    }
  }

  void _handleOtpValidationResponseForDevice<T>(Resource<T> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if (event is Error<T>) {
      setState(() => _isLoading = false);
      showModalBottomSheet(
          context: widget._scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: event.message);
          });
    }
    if(event is Success<T>) {
      setState(() => _isLoading = false);
      //display dialog for add device
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (v) => AddDeviceDialog(widget._scaffoldKey)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);

    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Enter OTP',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.textColorBlack,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 13),
                      Text(
                          'We’ve just sent a 6-digit code to your registered phone number. Enter the code to proceed.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.textColorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.normal)),
                      SizedBox(height: 30),
                      Styles.appEditText(
                          controller: _otpController,
                          hint: 'Enter OTP',
                          inputFormats: [
                            LengthLimitingTextInputFormatter(6),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          animateHint: true,
                          maxLength: 6,
                          startIcon: Icon(CustomFont.numberInput, color:Colors.textFieldIcon.withOpacity(0.2))
                      ),
                      SizedBox(height: 32),
                      OtpUssdInfoView(getUSSDKeyName(viewModel), defaultCode: "*5573*74#",),
                      SizedBox(height: 100),
                    ],
                  ),
                )),
            Styles.statefulButton2(
                elevation: 0,
                isValid: !_isLoading && _hasOtp,
                onClick: _subscribeToValidateOtp,
                text: 'Next',
                isLoading: _isLoading
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
