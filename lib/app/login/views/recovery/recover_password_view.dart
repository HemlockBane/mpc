import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoverPasswordScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoverPasswordScreen();
  }

}

class _RecoverPasswordScreen extends State<RecoverPasswordScreen> {
  bool _isLoading = false;

  void _subscribeUiToPasswordRecovery() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.initiateRecovery().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<RecoveryResponse>) {
        setState(() => _isLoading = false);
        _doOnError(event.message ?? "");
      }
      if(event is Success<RecoveryResponse>) {
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
          title: "Password Recovery Failed!",
          message: message,
          primaryButtonText: "Dismiss",
          useTextButton: true
      );
    }
  }

  void _navigateToUseUsername(RecoveryViewModel viewModel) {
    viewModel.setRecoveryMode(RecoveryMode.USERNAME_RECOVERY);
    Navigator.of(context)
        .popAndPushNamed(RecoveryControllerScreen.USERNAME_SCREEN);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.setRecoveryMode(RecoveryMode.PASSWORD_RECOVERY);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width
        ),
        child: IntrinsicHeight(
          child:  Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Enter Username',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.textColorBlack,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 13),
                          Text(
                              'Enter your Username to get started.',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.textColorBlack,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal)),
                          SizedBox(height: 46),
                          StreamBuilder(
                            stream: viewModel.passwordRecoveryForm.usernameStream,
                            builder: (context, snapshot) {
                              return Styles.appEditText(
                                  hint: 'Enter Username',
                                  inputFormats: [LengthLimitingTextInputFormatter(200)],
                                  animateHint: true,
                                  onChanged: viewModel.passwordRecoveryForm.onUsernameChanged,
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
                              "Can???t remember username?\nRecover Username",
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.textColorBlack, fontSize: 15, fontFamily: Styles.defaultFont, height: 1.4),
                            ).colorText({
                              "Recover Username": Tuple(Colors.primaryColor, () => _navigateToUseUsername(viewModel))
                            }, underline: false),
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    )),
                Styles.statefulButton(
                    elevation: 0,
                    stream: viewModel.passwordRecoveryForm.isValid,
                    onClick: _subscribeUiToPasswordRecovery,
                    text: 'Next',
                    isLoading: _isLoading
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }

}