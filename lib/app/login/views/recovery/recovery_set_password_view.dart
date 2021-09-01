import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/valid_password_checker.dart';
import 'package:provider/provider.dart';

class SetPasswordRecoveryView extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  SetPasswordRecoveryView(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _SetPasswordRecoveryView();
  }
}

class _SetPasswordRecoveryView extends State<SetPasswordRecoveryView> with Validators{
  TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isPasswordValid = false;
  bool _displayPasswordStrength = false;
  String? _errorText;

  Widget getPasswordToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(
            this._isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.colorFaded),
        onPressed: () {
          setState(() {
            this._isPasswordVisible = !_isPasswordVisible;
          });
        });
  }

  void _handlePasswordRecoveryResponse<T>(Resource<T> event) {
    if(event is Loading) setState(() => _isLoading = true);
    if (event is Error<T>) {
      setState(() => _isLoading = false);
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Password Update Failed!",
          message: event.message,
          useTextButton: true,
          primaryButtonText: "Dismiss",
          onPrimaryClick: () => Navigator.of(widget._scaffoldKey.currentContext ?? context).pop()
      );
    }
    if(event is Success<T>) {
      setState(() => _isLoading = false);
      showSuccess(
          widget._scaffoldKey.currentContext ?? context,
          title: "Password Updated",
          message: "Your password has been updated",
          primaryButtonText: "Proceed to Login",
          onPrimaryClick: () {
            Navigator.of(widget._scaffoldKey.currentContext!).pop();
            Navigator.of(widget._scaffoldKey.currentContext!)
                .pushNamedAndRemoveUntil(Routes.LOGIN, (route) => false);
          }
      );
    }
  }

  void _subscribeToUpdatePassword() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.passwordRecoveryForm.requestBody.password = _passwordController.text;
    viewModel.completeRecovery().listen(_handlePasswordRecoveryResponse);
  }
  
  @override
  void initState() {
    _passwordController.addListener(() {
      final validator = validatePasswordWithMessage(_passwordController.text);
      setState(() {
        _isPasswordValid = validator.first;
        _errorText = validator.second?.first;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ScrollView(
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
                    'Set new Password',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 44),
                  Focus(
                      onFocusChange: (v) {
                        setState(() {
                          _displayPasswordStrength = v;
                        });
                      },
                      child: Styles.appEditText(
                          controller: _passwordController,
                          hint: 'Enter New Password',
                          // errorText: _errorText,
                          animateHint: true,
                          startIcon: Icon(CustomIcons2.password, color: Colors.textFieldIcon.withOpacity(0.2)),
                          endIcon: getPasswordToggleIcon(context),
                          isPassword: !_isPasswordVisible
                      )
                  ),
                  SizedBox(height: 16),
                  if(_displayPasswordStrength) ValidPasswordChecker(_passwordController.text),
                  SizedBox(height: 100),
                ],
              ),
            )),
            Styles.statefulButton2(
                elevation: 0,
                isValid: !_isLoading && _isPasswordValid,
                onClick: _subscribeToUpdatePassword,
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
