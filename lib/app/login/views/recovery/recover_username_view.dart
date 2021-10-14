import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:provider/provider.dart';

class RecoverUsernameScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoverUsernameScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoverUsernameScreen();
  }
}

class _RecoverUsernameScreen extends State<RecoverUsernameScreen> {
  bool _isLoading = false;

  TextEditingController? _accountNumberController;

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

  void _navigateToUseBVN(RecoveryViewModel viewModel) {
    viewModel.userRecoveryForm.reset();
    Navigator.of(context).popAndPushNamed(RecoveryControllerScreen.USERNAME_BVN_SCREEN);
  }

  @override
  void initState() {
    _accountNumberController = TextEditingController();
    super.initState();
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
                    'Enter Account number',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 13),
                  Text('Enter your account number to get started',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.textColorBlack,
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),
                  SizedBox(height: 46),
                  StreamBuilder(
                    stream: viewModel.userRecoveryForm.keyInputStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'Account Number',
                          controller: _accountNumberController,
                          maxLength: 10,
                          inputType: TextInputType.number,
                          inputFormats: [FilteringTextInputFormatter.digitsOnly],
                          animateHint: true,
                          onChanged: viewModel.userRecoveryForm.onAccountNumberChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          startIcon: Icon(CustomFont.bankNumberInput, color: Colors.textFieldIcon.withOpacity(0.2))
                      );
                    },
                  ),
                  SizedBox(height: 14,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Can’t remember account number?\nUse BVN instead",
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontFamily: Styles.defaultFont, height: 1.4),
                    ).colorText({
                      "Use BVN instead": Tuple(Colors.primaryColor, () => _navigateToUseBVN(viewModel))
                    }, underline: false),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            )),
            Styles.statefulButton(
                elevation: 0,
                stream: viewModel.userRecoveryForm.isValid,
                onClick: subscribeUiToUsernameRecovery,
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
