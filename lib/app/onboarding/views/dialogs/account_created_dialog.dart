import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:provider/provider.dart';

class AccountCreatedDialog extends StatefulWidget {

  final AccountProfile accountProfile;
  final String username;
  final String password;

  AccountCreatedDialog(
      this.accountProfile,
      this.username,
      this.password
  );

  @override
  State<StatefulWidget> createState() => _AccountCreatedDialog();

}

class _AccountCreatedDialog extends State<AccountCreatedDialog> with CompositeDisposableWidget {

  late final LoginViewModel _viewModel;

  bool _isLoading = false;

  @override
  void initState() {
    _viewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.initState();
  }

  void _subscribeUiToLogin() {
    _viewModel.loginWithPassword(widget.username, widget.password).listen((event) {
      if(event is Loading) {
        setState(() {
          _isLoading = true;
        });
      }
      else if(event is Error<User>) {
        setState(() {
          _isLoading = false;
        });
        showError(context, title: "Login Failed!", message: event.message);
      }
      else if(event is Success) {
        setState(() {
          _isLoading = false;
        });
        PreferenceUtil.setLoginMode(LoginMode.FULL_ACCESS);
        PreferenceUtil.saveLoggedInUser(event.data!);
        PreferenceUtil.saveUsername(event.data?.username ?? "");
        Navigator.pushNamedAndRemoveUntil(context, Routes.DASHBOARD, (q) => false);
      }
    }).disposedBy(this);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 13,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_circular_check_mark.svg',
          color: Colors.solidGreen,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text("Account Created",
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 21, vertical: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.deepGrey.withOpacity(0.13)),
                    child: Column(
                      children: [
                        Text("Your Account Number is"),
                        SizedBox(height: 11),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(child: Text(
                              widget.accountProfile.accountNumber ?? "",
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                            )),
                            SizedBox(width: 4,),
                            TextButton.icon(
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text:widget.accountProfile.accountNumber  ?? ""));
                                },
                                icon: SvgPicture.asset("res/drawables/ic_copy_full.svg", color: Colors.primaryColor,),
                                label: Text(
                                  "Copy",
                                  style: TextStyle(
                                      color: Colors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14
                                  ),)
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.statefulButton2(
                        isValid: true,
                        isLoading: _isLoading,
                        elevation: 0.5,
                        onClick: _subscribeUiToLogin,
                        text: "Go to Login",
                      )),
                  SizedBox(height: 32),
                ],
              ),
            )
          ],
        ));
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}