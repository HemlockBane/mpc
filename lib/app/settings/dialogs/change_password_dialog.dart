import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_password_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

///
///@author Paul Okeke
///
class ChangePasswordDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePasswordDialog();
}

class _ChangePasswordDialog extends State<ChangePasswordDialog> {
  bool _isOldPasswordVisible  = false;
  bool _isNewPasswordVisible  = false;
  bool _isLoading = false;

  void subscribeUiToChangePassword() {
    final viewModel = Provider.of<ChangePasswordViewModel>(context, listen: false);
    viewModel.changePassword().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      else if(event is Success) {
        setState(() => _isLoading = false);
        showSuccess(
            context,
            title: "Password Changed",
            message: "Password was updated successfully",
            onPrimaryClick: () {
              Navigator.of(context).pop();
            }
        );
      }
      else if(event is Error<bool>) {
        setState(() {_isLoading = false;});
          showError(
              context,
              title: "Password Change Failed!",
              message: event.message
          );
      }
    });
  }

  Widget _changePasswordForm() {
    final viewModel = Provider.of<ChangePasswordViewModel>(context, listen: false);
    return Expanded(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 21),
              StreamBuilder(
                  stream: viewModel.oldPasswordStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Styles.appEditText(
                          hint: 'Enter Current Password',
                          onChanged: viewModel.onOldPasswordChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          animateHint: false,
                          drawablePadding: EdgeInsets.only(left: 4, right: 4),
                          startIcon: Icon(
                              CustomIcons2.password,
                              color: Color(0XFF111827).withOpacity(0.5)
                          ),
                          endIcon: IconButton(
                              icon: Icon(
                                  this._isOldPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0XFF111827).withOpacity(0.3)
                              ),
                              onPressed: () {
                                setState(() {
                                  this._isOldPasswordVisible = !_isOldPasswordVisible;
                                });
                              }),
                          isPassword: !_isOldPasswordVisible),
                    );
                  }),
              SizedBox(height: 16),
              StreamBuilder(
                  stream: viewModel.newPasswordStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom * 0.6
                      ),
                      child: Styles.appEditText(
                          hint: 'Enter New Password',
                          onChanged: viewModel.onNewPasswordChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          animateHint: false,
                          drawablePadding: EdgeInsets.only(left: 4, right: 4),
                          startIcon: Icon(
                              CustomIcons2.password,
                              color: Color(0XFF111827).withOpacity(0.5)
                          ),
                          endIcon: IconButton(
                              icon: Icon(
                                  this._isNewPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0XFF111827).withOpacity(0.3)
                              ),
                              onPressed: () {
                                setState(() {
                                  this._isNewPasswordVisible =
                                  !_isNewPasswordVisible;
                                });
                              }),
                          isPassword: !_isNewPasswordVisible
                      ),
                    );
                  }),
              SizedBox(height: 32),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  child: Styles.statefulButton(
                      stream: viewModel.isValid,
                      elevation: 0.5,
                      isLoading: _isLoading,
                      onClick: () => subscribeUiToChangePassword(),
                      text: 'Change Password'
                  )
              ),
              SizedBox(height: 42)
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Settings',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack
              )
          ),
          backgroundColor: Colors.backgroundWhite.withOpacity(0.05),
          elevation: 0
      ),
      body: SessionedWidget(
        context: context,
        child: Container(
          padding: EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
              color: Colors.backgroundWhite,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("res/drawables/ic_app_new_bg.png")
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Change Password",
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Customize your Moniepoint experience",
                  style: TextStyle(
                    color: Colors.textColorBlack.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 21),
              _changePasswordForm()
            ],
          ),
        ),
      ),
    );
  }
}
