import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_password_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

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
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop(event.data);
        });
      }
      else if(event is Error<bool>) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChangePasswordViewModel>(context, listen: false);

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_change_password.svg',
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 16,
        content: Wrap(children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16,),
                Center(
                  child: Text('Change Password',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.solidDarkBlue)),
                ),
                SizedBox(height: 36),
                StreamBuilder(
                    stream: viewModel.oldPasswordStream,
                    builder: (context, snapshot) {
                      return Padding(
                          padding: EdgeInsets.only(left: 16, right: 16),
                          child: Styles.appEditText(
                              hint: 'Enter Current Password',
                              onChanged: viewModel.onOldPasswordChanged,
                              errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              animateHint: false,
                              drawablePadding: EdgeInsets.only(left: 4, right: 4),
                              startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                              endIcon: IconButton(
                                  icon: Icon(this._isOldPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.colorFaded),
                                  onPressed: () {
                                    setState(() {
                                      this._isOldPasswordVisible = !_isOldPasswordVisible;
                                    });
                                  }
                              ),
                              isPassword: !_isOldPasswordVisible
                          ),
                      );
                    }),
                SizedBox(height: 16,),
                StreamBuilder(
                    stream: viewModel.newPasswordStream,
                    builder: (context, snapshot) {
                      return Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom * 0.6),
                          child: Styles.appEditText(
                              hint: 'Enter New Password',
                              onChanged: viewModel.onNewPasswordChanged,
                              errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              animateHint: false,
                              drawablePadding: EdgeInsets.only(left: 4, right: 4),
                              startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                              endIcon: IconButton(
                                  icon: Icon(this._isNewPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.colorFaded),
                                  onPressed: () {
                                    setState(() {
                                      this._isNewPasswordVisible = !_isNewPasswordVisible;
                                    });
                                  }
                              ),
                              isPassword: !_isNewPasswordVisible
                          ),
                      );
                    }),
                SizedBox(height: 32,),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    child: Styles.statefulButton(
                        stream: viewModel.isValid,
                        elevation: 0.5,
                        isLoading: _isLoading,
                        onClick: () => subscribeUiToChangePassword(),
                        text: 'Change Password')),
                SizedBox(height: 42)
              ],
            ),
          )
        ])
    );
  }
}
