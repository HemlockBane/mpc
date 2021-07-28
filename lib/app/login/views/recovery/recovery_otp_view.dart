import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/add_device_dialog.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_answer_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
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
      showError(widget._scaffoldKey.currentContext ?? context, message: event.message);
    }
  }

  void _startLivelinessTest(LivelinessVerificationFor verificationFor, String validationKey) async {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    final key = verificationFor == LivelinessVerificationFor.USERNAME_RECOVERY
        ? viewModel.userRecoveryForm.getKey
        : (verificationFor == LivelinessVerificationFor.PASSWORD_RECOVERY)
        ? viewModel.passwordRecoveryForm.requestBody.username
        : UserInstance().getUser()?.username;

    final validationResponse = await Navigator.of(widget._scaffoldKey.currentContext ?? context)
        .pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": verificationFor,
      "key" : key,
      "otpValidationKey": validationKey
    });

    if(validationResponse != null && validationResponse is RecoveryResponse) {
      if(verificationFor == LivelinessVerificationFor.USERNAME_RECOVERY) {
        PreferenceUtil.saveUsername(validationResponse.username!);
        Navigator.of(context)
            .pushNamed(RecoveryControllerScreen.USERNAME_DISPLAY_SCREEN,
            arguments: validationResponse.username);
      } else if(verificationFor == LivelinessVerificationFor.PASSWORD_RECOVERY) {
        if(validationResponse.livelinessCheckRef == null
            || validationResponse.livelinessCheckRef?.isEmpty == true) {
          //Something wrong happened here
          showError(widget._scaffoldKey.currentContext ?? context, message: "Validation failed");
          return;
        }
        viewModel.setLivelinessCheckRef(validationResponse.livelinessCheckRef);
        Navigator.of(context)
            .pushNamed(RecoveryControllerScreen.SET_PASSWORD);
      }
    }

    if(validationResponse != null && validationResponse is ValidateAnswerResponse){
      showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (v) => AddDeviceDialog(widget._scaffoldKey, validationResponse.livelinessValidationKey ?? "")
      );
    }
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

  void _handleValidateOtpResponse(Resource<RecoveryResponse> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if (event is Error<RecoveryResponse>) {
      setState(() => _isLoading = false);
      showError(widget._scaffoldKey.currentContext ?? context, message: event.message);
    }
    if(event is Success<RecoveryResponse>) {
      setState(() => _isLoading = false);
      _startLivelinessTest(
          LivelinessVerificationFor.PASSWORD_RECOVERY, event.data?.otpValidationKey ?? ""
      );
    }
  }

  void _handleOtpValidationResponseForDevice(Resource<ValidateAnswerResponse> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if (event is Error<ValidateAnswerResponse>) {
      setState(() => _isLoading = false);
      showError(widget._scaffoldKey.currentContext ?? context, message: event.message);
    }
    if(event is Success<ValidateAnswerResponse>) {
      setState(() => _isLoading = false);
      //display dialog for add device
      _startLivelinessTest(LivelinessVerificationFor.REGISTER_DEVICE, event.data!.validationKey!);
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
                      OtpUssdInfoView(
                        getUSSDKeyName(viewModel),
                        defaultCode: "*5573*74#",
                        message: "Didn’t get the code? Dial {}",
                      ),
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
