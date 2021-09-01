import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class RecoverUsernameBVNScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoverUsernameBVNScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoverUsernameScreen();
  }
}

class _RecoverUsernameScreen extends State<RecoverUsernameBVNScreen> {
  bool _isLoading = false;

  void subscribeUiToUsernameRecovery() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.initiateRecovery().listen((event) {
      if (event is Loading) setState(() => _isLoading = true);
      if (event is Error<RecoveryResponse>) {
        setState(() => _isLoading = false);
        _doOnError(event.message ?? "");
      }
      if (event is Success<RecoveryResponse>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed(RecoveryControllerScreen.RECOVERY_OTP);
      }
    });
  }

  void _doOnError(String message) {
    //The flow specifies that we should navigate to the otp
    //If the status is true. The body of the request is usually empty
    if(message.contains("fulfilling your request")) {
      Navigator.of(context).pushNamed(RecoveryControllerScreen.RECOVERY_OTP);
    } else {
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Username Recovery Failed!",
          message: message,
          primaryButtonText: "Dismiss",
          useTextButton: true
      );
    }
  }

  void _navigateToUseAccountNumber(RecoveryViewModel viewModel) {
    viewModel.userRecoveryForm.reset();
    Navigator.of(context).popAndPushNamed(RecoveryControllerScreen.USERNAME_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.setRecoveryMode(RecoveryMode.USERNAME_RECOVERY);

    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Expanded(child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter BVN',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 36),
                  StreamBuilder(
                    stream: viewModel.userRecoveryForm.keyInputStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'Enter Bank Verification Number',
                          maxLength: 11,
                          inputType: TextInputType.number,
                          inputFormats: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          animateHint: true,
                          onChanged: viewModel.userRecoveryForm.onBVNChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          startIcon: Icon(CustomFont.bankNumberInput,
                              color: Colors.textFieldIcon.withOpacity(0.2)));
                    },
                  ),
                  SizedBox(height: 20),
                  OtpUssdInfoView(
                    "Onboarding Phone Number Validation OTP Mobile",
                    defaultCode: "*5573*70#",
                    message: "Dial {} on your registered phone number to get your BVN",
                  ),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () => _navigateToUseAccountNumber(viewModel),
                        child: Text(
                          'Use Account Number',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.primaryColor
                          )),
                        style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size(40, 0)),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 0, vertical: 4)),
                        )
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            )),
            Styles.statefulButton(
                elevation: 0,
                stream: viewModel.userRecoveryForm.isValid,
                onClick: subscribeUiToUsernameRecovery,
                text: 'Next',
                isLoading: _isLoading),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
