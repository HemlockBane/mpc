import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/biometric_login_screen.dart';
import 'package:moniepoint_flutter/app/login/views/login_response_observer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:provider/provider.dart';

import 'dialogs/recover_credentials.dart';

///@author Paul Okeke
///

class LoginView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.primaryColor,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("res/drawables/ic_app_new_bg.png")
            )
        ),
        padding: EdgeInsets.only(top: 64, left: 20, right: 20, bottom: 0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  SvgPicture.asset("res/drawables/ic_m_2.svg", height: 76, width: 76),
                  Spacer(),
                  Styles.makeTextWithIcon(
                      text: "Support",
                      src: "res/drawables/ic_support_v2.svg",
                      spacing: 5,
                      width: 25,
                      height: 22,
                      onClick: () => Navigator.of(context).pushNamed(Routes.SUPPORT)
                  ),
                  SizedBox(width: 18),
                  Styles.makeTextWithIcon(
                      text: "Branches",
                      spacing: 0.2,
                      width: 22,
                      height: 26,
                      src: "res/drawables/ic_branches.svg",
                      onClick: () => Navigator.of(context).pushNamed(Routes.BRANCHES)
                  )
                ],
              )
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Text(
                      "Welcome back,\nAdrian",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white
                      ),
                    ),
                    SizedBox(height: 25,),
                    _LoginBox(),
                    SizedBox(height: 46),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


///_LoginBox
///
class _LoginBox extends StatefulWidget {

  @override
  State<StatefulWidget> createState() =>_LoginBoxState();

}

class _LoginBoxState extends State<_LoginBox> with CompositeDisposableWidget {

  late final LoginViewModel _viewModel;
  late final LoginResponseObserver _loginResponseObserver;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    _viewModel = Provider.of<LoginViewModel>(context, listen: false);
    _viewModel.getSystemConfigurations().listen((event) {}).disposedBy(this);

    UserInstance().resetSession();
    setupViewDependencies();
    super.initState();

    _loginResponseObserver = LoginResponseObserver(
        context: context,
        passwordController: _passwordController,
        viewModel: _viewModel,
    )..addStateListener((state) {
      setState(() {});
    });
    _initSavedUsername();
  }

  void setupViewDependencies() {
    _usernameController.addListener(() => validateForm());
    _passwordController.addListener(() => validateForm());
  }

  void validateForm() {
    if(_usernameController.text.isNotEmpty
        && _passwordController.text.isNotEmpty && _viewModel.isLoginFormValid) {
      return;
    }
    setState(() {
      _viewModel.validateLoginForm(
          _usernameController.text, _passwordController.text
      );
    });
  }

  void _displayRecoverCredentials() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet2(
              height: 390,
              dialogIcon: SvgPicture.asset(
                'res/drawables/ic_info.svg',
                color: Colors.primaryColor,
                width: 40,
                height: 40,
              ),
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              centerBackgroundPadding: 15,
              content: RecoverCredentialsDialogLayout.getLayout(context)
          );
        });
  }

  void _initSavedUsername() {
    _viewModel.savedUsername = PreferenceUtil.getSavedUsername();
    if (_viewModel.savedUsername != null && _viewModel.savedUsername!.length > 3) {
      final savedHashUsername = "${_viewModel.savedUsername?.substring(0, 3)}#######";
      _usernameController.text = savedHashUsername;
    }
  }

  void _subscribeUiToLogin() {
    FocusManager.instance.primaryFocus?.unfocus();

    String username = _usernameController.text;
    String password = _passwordController.text;

    String loginUsername = (username.contains("#"))
        ? _viewModel.savedUsername ?? ""
        : username;

    _viewModel.loginWithPassword(loginUsername, password)
        .listen(_loginResponseObserver.observe)
        .disposedBy(this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 27, left: 19, right: 19, bottom: 0),
            child: Column(
              children: [
                Styles.appEditText(
                    hint: 'Username',
                    fillColor: Color(0xffCED2D9).withOpacity(0.2),
                    borderColor: Colors.transparent,
                    controller: _usernameController,
                    animateHint: true,
                    drawablePadding: EdgeInsets.only(left: 4, right: 4),
                    fontSize: 15,
                    padding: EdgeInsets.only(top: 22, bottom: 22),
                    startIcon: Icon(
                      CustomIcons2.username,
                      color: Colors.textHintColor.withOpacity(0.3),
                      size: 24,
                    ),
                    focusListener: (bool) => this.setState(() {})
                ),
                SizedBox(height: 22),
                Styles.appEditText(
                  controller: _passwordController,
                    hint: 'Password',
                    fillColor: Color(0xffCED2D9).withOpacity(0.2),
                    borderColor: Colors.transparent,
                    animateHint: true,
                    drawablePadding: EdgeInsets.only(left: 4, right: 4),
                    fontSize: 15,
                    padding: EdgeInsets.only(top: 22, bottom: 22),
                    endIcon: IconButton(
                        icon: Icon(
                            this._isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.textHintColor.withOpacity(0.3)
                        ),
                        onPressed: () {
                          setState(() {
                            this._isPasswordVisible = !_isPasswordVisible;
                          });
                        }),
                    startIcon: Icon(
                      CustomIcons2.password,
                      color: Colors.textHintColor.withOpacity(0.3),
                      size: 24,
                    ),
                    focusListener: (bool) => this.setState(() {}),
                    isPassword: !_isPasswordVisible
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _displayRecoverCredentials,
                      child: Text('Forgot Username or Password?'),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                          foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(
                                  fontFamily: Styles.defaultFont,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                              )
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 26),
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Styles.statefulButton2(
                                isValid: _viewModel.isLoginFormValid,
                                padding: 20,
                                elevation: _viewModel.isLoginFormValid && !_viewModel.isLoggingIn ? 4 : 0,
                                onClick: _subscribeUiToLogin,
                                text: "Login",
                                isLoading: _viewModel.isLoggingIn,
                            ),
                          ),
                          BiometricLoginButton(
                            loginViewModel: this._viewModel,
                            loginResponseObserver: _loginResponseObserver,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26),
              ],
            ),
          ),
          _USSDWidget()
        ],
      ),
    );
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}

///BiometricLoginButton
///
class BiometricLoginButton extends StatelessWidget {

  BiometricLoginButton({
      required this.loginViewModel,
      required this.loginResponseObserver
  });

  final LoginViewModel loginViewModel;
  final LoginResponseObserver loginResponseObserver;

  Future<bool> checkBiometricStatus(LoginViewModel viewModel) async {
    BiometricHelper _biometricHelper = BiometricHelper.getInstance();
    await Future.delayed(Duration(milliseconds: 50));
    return viewModel.canLoginWithBiometric(_biometricHelper);
  }

  static Future<BiometricLoginScreen> getBiometricLoginScreen(
      LoginViewModel loginViewModel,
      LoginResponseObserver loginResponseObserver) async {

    BiometricHelper _biometricHelper = BiometricHelper.getInstance();
    BiometricType biometricType = await _biometricHelper.getBiometricType();
    String actionText = "";

    if (biometricType == BiometricType.FACE_ID) {
      actionText = "FaceID Unlock";
    } else if (biometricType == BiometricType.FINGER_PRINT) {
      actionText = "Fingerprint Unlock";
    }
    return BiometricLoginScreen(
      responseObserver: loginResponseObserver,
      pageDescription: "Welcome back,\n${PreferenceUtil.getSavedUsername()}",
      pageActionText: actionText,
      fingerPrintAction: (key, username) {
        loginViewModel.loginWithFingerPrint(key, username)
            .listen(loginResponseObserver.observe);
      },
    );
  }

  void _navigateToBiometricScreen(BuildContext context) async {
    BiometricLoginScreen biometricLoginScreen = await getBiometricLoginScreen(
        loginViewModel, loginResponseObserver
    );
    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: this.loginViewModel,
              child: biometricLoginScreen,
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: checkBiometricStatus(loginViewModel),
        builder: (mContext, AsyncSnapshot<bool> snapShot) {
          if (!snapShot.hasData) return SizedBox.shrink();
          if (snapShot.hasData && snapShot.data == false) return SizedBox.shrink();
          return Row(
            children: [
              SizedBox(width: 16),
              Styles.imageButton(
                  onClick: () => _navigateToBiometricScreen(context),
                  color: Colors.primaryColor.withOpacity(0.1),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 14.5, bottom: 14.5),
                  image: Platform.isAndroid
                      ? SvgPicture.asset('res/drawables/ic_finger_print.svg')
                      : SvgPicture.asset('res/drawables/ic_login_face.svg')
              )
            ],
          );
        });
  }
}

///_USSDWidget
///
///
class _USSDWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Tuple<String, String> codes = OtpUssdInfoView.getUSSDDialingCodeAndPreview(
        "Main Menu", defaultCode: "*5573#"
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.primaryColor.withOpacity(0.05),
        border: Border(top: BorderSide(color: Colors.primaryColor.withOpacity(0.1), width: 0.8))
      ),
      child: Container(
        margin: EdgeInsets.only(top: 0, bottom: 0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            highlightColor: Colors.grey.withOpacity(0.05),
            overlayColor: MaterialStateProperty.all(
                Colors.primaryColor.withOpacity(0.05)
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)
            ),
            onTap: () => openUrl("tel:${codes.first}"),
            child: Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 19, vertical: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available on USSD',
                          style: TextStyle(
                              fontFamily: Styles.defaultFont,
                              color: Colors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text('Transfer, Airtime & Pay Bills Offline!',
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: Styles.defaultFont,
                                color: Colors.textSubColor.withOpacity(0.6)
                            )),
                      ],
                    )),
                    SizedBox(width: 8),
                    Text(codes.second,
                        style: TextStyle(
                            fontFamily: Styles.defaultFont,
                            fontSize: 32,
                            color: Colors.primaryColor,
                            fontWeight: FontWeight.w600
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}