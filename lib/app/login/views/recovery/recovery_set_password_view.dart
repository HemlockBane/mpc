import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
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
      Widget bottomSheetView = BottomSheets.displaySuccessModal(
          widget._scaffoldKey.currentContext!,
          title: "Password Updated",
          message: "Your password has been updated",
          onClick: () {
            Navigator.of(widget._scaffoldKey.currentContext!).pop();
            Navigator.of(widget._scaffoldKey.currentContext!).pushNamedAndRemoveUntil('/login', (route) => false);
          }
      );
      showModalBottomSheet(
          context: widget._scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => bottomSheetView
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
                    'Update Password',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.colorPrimaryDark,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 44),
                  Styles.appEditText(
                      controller: _passwordController,
                      hint: 'Enter New Password',
                      errorText: _errorText,
                      animateHint: true,
                      startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                      endIcon: getPasswordToggleIcon(context),
                      isPassword: !_isPasswordVisible),
                  SizedBox(height: 16),
                  SizedBox(height: 100),
                ],
              ),
            )),
            Styles.statefulButton2(
                elevation: 0,
                isValid: !_isLoading && _isPasswordValid,
                onClick: _subscribeToUpdatePassword,
                text: 'Continue',
                isLoading: _isLoading
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
