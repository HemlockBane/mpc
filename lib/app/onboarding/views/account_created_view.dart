import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/account_profile_result.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:provider/provider.dart';

///
///@author Paul Okeke
///
class AccountCreatedView extends StatefulWidget {

  AccountCreatedView({
    required this.accountProfile,
    required this.username,
    required this.password
  });

  final AccountProfile accountProfile;
  final String username;
  final String password;

  @override
  State<StatefulWidget> createState() => _AccountCreatedViewState();


}

class _AccountCreatedViewState extends State<AccountCreatedView> with CompositeDisposableWidget {

  late final LoginViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<LoginViewModel>(context, listen: false);
    super.initState();
  }

  void _subscribeUiToLogin() {
    _viewModel.loginWithPassword(widget.username, widget.password).listen((event) {
      if(event is Loading) {
        setState(() {
          _viewModel.isLoggingIn = true;
        });
      }
      else if(event is Error<User>) {
        setState(() {
          _viewModel.isLoggingIn = false;
        });
        showError(context, title: "Login Failed!", message: event.message);
      }
      else if(event is Success) {
        setState(() {
          _viewModel.isLoggingIn = false;
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.backgroundWhite,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("res/drawables/ic_app_new_bg.png")
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SvgPicture.asset("res/drawables/ic_check_mark_round_alt.svg"),
            ),
            SizedBox(height: 24,),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Account Created\nSuccessfully",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                ),
              ),
            ),
            SizedBox(height: 21),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight:Radius.circular(16)
                  )
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 20, right: 20, top: 56),
                        padding: EdgeInsets.only(top: 50, bottom: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0XFF0357EE).withOpacity(0.06)
                        ),
                        child: Column(
                          children: [
                            Text(
                              "Your Account Number is",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.textColorBlack
                              ),
                            ),
                            Text(
                              widget.accountProfile.accountNumber ?? "0011357716",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.solidDarkBlue
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 28,
                          child: SvgPicture.asset(
                              "res/drawables/ic_moniepoint_cube_2.svg",
                              color: Colors.primaryColor,
                              width: 59,
                              height: 59,
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 38),
                  TextButton.icon(
                      onPressed: () {

                      },
                      icon: SvgPicture.asset("res/drawables/ic_phone_contact.svg", color: Colors.primaryColor,),
                      label: Text(
                          "Save to Contacts",
                          style: TextStyle(
                              color: Colors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                          )
                      )
                  ),
                  SizedBox(height: 32),
                  TextButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.accountProfile.accountNumber  ?? ""));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Copied to Clipboard!"))
                        );
                      },
                      icon: SvgPicture.asset("res/drawables/ic_copy_full.svg", color: Colors.primaryColor),
                      label: Text(
                          "Tap to Copy",
                          style: TextStyle(
                              color: Colors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13
                          )
                      )
                  ),
                  SizedBox(height: 100),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Styles.statefulButton2(
                      isValid: true,
                      isLoading: _viewModel.isLoggingIn,
                      elevation: 0.5,
                      onClick: _subscribeUiToLogin,
                      text: "Continue to Dashboard",
                    ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}