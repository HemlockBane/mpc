import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/model/data/security_flag.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/login_options.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/recover_credentials.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/unrecognized_device_dialog.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/custom_icons2_icons.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/timeout_reason.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String savedHashUsername = "";
  String? unHashedUsername = "";

  late final AnimationController _animController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

  late final _ussdOffsetAnimation =
      Tween<Offset>(begin: Offset(0, 12), end: Offset(0, 0)).animate(
          CurvedAnimation(parent: _animController, curve: Curves.decelerate));

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  bool _alreadyInSessionError = false;
  BiometricHelper? _biometricHelper;

  @override
  void initState() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    viewModel.getSystemConfigurations().listen((event) {});

    _usernameController.addListener(() => validateForm());
    _passwordController.addListener(() => validateForm());

    super.initState();

    _initSavedUsername();
    _animController.forward();

    _initializeAndStartBiometric();
  }

  void _initializeAndStartBiometric() async {
    _biometricHelper = await BiometricHelper.initialize(
        keyFileName: "moniepoint_iv",
        keyStoreName: "AndroidKeyStore",
        keyAlias: "teamapt-moniepoint");
    if (!_alreadyInSessionError) _startFingerPrintLoginProcess();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _initSavedUsername() {
    this.unHashedUsername = PreferenceUtil.getSavedUsername();
    if (unHashedUsername != null && unHashedUsername!.length > 3) {
      savedHashUsername = "${unHashedUsername?.substring(0, 3)}#######";
      _usernameController.text = savedHashUsername;
    }
  }

  void validateForm() {
    setState(() {
      _isFormValid = _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Widget makeTextWithIcon(
      {required String src,
      required String text,
      VoidCallback? onClick,
      required double width,
      required double height,
      double spacing = 4}) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            src,
            fit: BoxFit.contain,
            width: width,
            height: height,
          ),
          SizedBox(height: spacing),
          Text(text,
              style: TextStyle(
                  fontFamily: 'CircularStd', fontSize: 12, color: Colors.white))
        ],
      ),
      onTap: onClick,
    );
  }

  Widget _buildTopMenu() {
    return Stack(
      children: [
        SvgPicture.asset(
          "res/drawables/bg.svg",
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.075, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              makeTextWithIcon(
                  text: "Support",
                  src: "res/drawables/support_v2_icon.svg",
                  spacing: 5,
                  width: 27,
                  height: 24,
                  onClick: () =>
                      Navigator.of(context).pushNamed(Routes.SUPPORT)),
              SizedBox(width: 18),
              makeTextWithIcon(
                  text: "Branches",
                  spacing: 0.2,
                  width: 24,
                  height: 28,
                  src: "res/drawables/branches.svg",
                  onClick: () =>
                      Navigator.of(context).pushNamed(Routes.BRANCHES))
            ],
          ),
        ),
        // Align(
        //   alignment: Alignment,
        //   child: Container(
        //     color: Colors.black,
        //     height: 20,
        //     width: 20,
        //   ),
        // )
      ],
    );
  }

  Widget _buildCenterBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('Welcome back, Adrian',
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
        ),
        // SizedBox(height: 5),
        _buildLoginBox(context)
      ],
    );
  }

  void _subscribeUiToLogin(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    String username = _usernameController.text;
    String password = _passwordController.text;

    String loginUsername =
        (username.contains("#")) ? unHashedUsername ?? "" : username;
    viewModel
        .loginWithPassword(loginUsername, password)
        .listen(_loginResponseObserver);
  }

  void _loginResponseObserver(Resource<User> event) {
    if (event is Loading) setState(() => _isLoading = true);
    if (event is Error<User>) {
      setState(() => _isLoading = false);
      _passwordController.clear();
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            //TODO we might need a better way of identifying how to detect an upgrade
            if (event.message?.contains("version") == true) {
              return BottomSheets.displayWarningDialog(
                  'Update Moniepoint App', event.message ?? "", () {
                Navigator.of(context).pop();
                final viewModel =
                    Provider.of<LoginViewModel>(context, listen: false);
                dialNumber(viewModel.getApplicationPlayStoreUrl());
              }, buttonText: "Upgrade App");
            }
            return BottomSheets.displayErrorModal(context,
                message: event.message);
          });
    }
    if (event is Success<User>) {
      _passwordController.clear();
      setState(() => _isLoading = false);
      PreferenceUtil.setLoginMode(LoginMode.FULL_ACCESS);
      PreferenceUtil.saveLoggedInUser(event.data!);
      PreferenceUtil.saveUsername(event.data?.username ?? "");
      checkSecurityFlags();
    }
  }

  void loginSuccessfully() {
    Navigator.popAndPushNamed(context, Routes.DASHBOARD);
  }

  void checkSecurityFlags() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    var flag = viewModel.securityFlagQueue;
    if (flag?.isEmpty == true) return loginSuccessfully();
    var queue = flag?.removeFirst();

    if (queue == SecurityFlag.ADD_DEVICE) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (b) => UnRecognizedDeviceDialog(() => checkSecurityFlags()));
    }
  }

  void _startFingerPrintLoginProcess() async {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    final biometricType = await _biometricHelper?.getBiometricType();
    final hasFingerPrint =
        (await _biometricHelper?.getFingerprintPassword()) != null;
    if (biometricType != BiometricType.NONE) {
      if (PreferenceUtil.getFingerPrintEnabled() && hasFingerPrint) {
        _biometricHelper?.authenticate(authenticationCallback: (key, msg) {
          if (key != null) {
            viewModel
                .loginWithFingerPrint(
                    key, PreferenceUtil.getAuthFingerprintUsername() ?? "")
                .listen(_loginResponseObserver);
          }
        });
      }
    } else {
      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.second ?? "")));
    }
  }

  void _displayRecoverCredentials() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet(
              height: 420,
              centerImageRes: 'res/drawables/ic_key.svg',
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              content: RecoverCredentialsDialogLayout.getLayout(context));
        });
  }

  void _displayLoginOptions() async {
    final biometricHelper = BiometricHelper.getInstance();
    final biometricType = await biometricHelper.getBiometricType();
    final fingerprintPassword = await biometricHelper.getFingerprintPassword();
    final isBiometricAvailable = biometricType != BiometricType.NONE;
    final isFingerprintSetup = fingerprintPassword != null;

    final result = await showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet(
              height: 420, //this is like our guideline
              centerImageRes: 'res/drawables/ic_login_options.svg',
              centerBackgroundPadding: 18,
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              content: LoginOptionsDialogLayout.getLayout(context,
                  isFingerprintAvailable: isBiometricAvailable,
                  hasFingerprintPassword: isFingerprintSetup));
        });

    if (result is String && result == "fingerprint") {
      _startFingerPrintLoginProcess();
    }
  }

  Widget _buildLoginBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 11, left: 16, right: 16, bottom: 18),
      child: Column(
        children: [
          Styles.appEditText(
              hint: 'Username',
              fillColor: Color(0xFFF5F6F7),
              controller: _usernameController,
              animateHint: true,
              drawablePadding: EdgeInsets.only(left: 4, right: 4),
              fontSize: 15,
              padding: EdgeInsets.only(top: 22, bottom: 22),
              startIcon: Icon(
                CustomIcons2.username,
                color: Colors.colorFaded,
                size: 20,
              ),
              focusListener: (bool) => this.setState(() {})),
          SizedBox(height: 22),
          Styles.appEditText(
              controller: _passwordController,
              hint: 'Password',
              fillColor: Color(0xFFF5F6F7),
              animateHint: true,
              drawablePadding: EdgeInsets.only(left: 4, right: 4),
              fontSize: 15,
              padding: EdgeInsets.only(top: 22, bottom: 22),
              endIcon: IconButton(
                  icon: Icon(
                      this._isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.colorFaded),
                  onPressed: () {
                    setState(() {
                      this._isPasswordVisible = !_isPasswordVisible;
                    });
                  }),
              startIcon: Icon(
                CustomIcons2.password,
                color: Colors.colorFaded,
                size: 20,
              ),
              focusListener: (bool) => this.setState(() {}),
              isPassword: !_isPasswordVisible),
          // SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                onPressed: _displayRecoverCredentials,
                child: Text('Recover Credentials'),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                    foregroundColor:
                        MaterialStateProperty.all(Colors.primaryColor),
                    textStyle: MaterialStateProperty.all(TextStyle(
                        fontFamily: Styles.defaultFont,
                        fontSize: 14,
                        fontWeight: FontWeight.normal))),
              ),
            ],
          ),
          SizedBox(height: 22),
          Styles.statefulButton2(
              isValid: _isFormValid,
              padding: 20,
              elevation: _isFormValid && !_isLoading ? 4 : 0,
              onClick: () => _subscribeUiToLogin(context),
              text: "Login",
              isLoading: _isLoading),
        ],
      ),
    );
  }

  Widget _bottomUSSDWidget() {
    Tuple<String, String> codes = OtpUssdInfoView.getUSSDDialingCodeAndPreview(
        "Main Menu",
        defaultCode: "*5573#");
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border:
              Border.all(color: Colors.cardBorder.withOpacity(0.05), width: 1),
          boxShadow: [
            BoxShadow(
                color: Colors.cardBorder.withOpacity(0.2),
                offset: Offset(0, 8),
                blurRadius: 6)
          ]),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: InkWell(
          highlightColor: Colors.grey.withOpacity(0.05),
          overlayColor:
              MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          onTap: () => dialNumber("tel:${codes.first}"),
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USSD Quick Actions',
                        style: TextStyle(
                            fontFamily: Styles.defaultFont,
                            color: Colors.darkBlue,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text('Transfer, Airtime & Pay Bills Offline!',
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: Styles.defaultFont,
                              color: Colors.textSubColor.withOpacity(0.6))),
                    ],
                  )),
                  SizedBox(width: 8),
                  Text(codes.second,
                      style: TextStyle(
                          fontFamily: Styles.defaultFont,
                          fontSize: 32,
                          color: Colors.primaryColor,
                          fontWeight: FontWeight.w600))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSessionReason(Tuple<String, SessionTimeoutReason>? reason) {
    if (reason == null) return;
    if (reason.second == SessionTimeoutReason.INACTIVITY &&
        !_alreadyInSessionError) {
      _alreadyInSessionError = true;
      UserInstance().resetSession();
      Future.delayed(Duration(milliseconds: 150), () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return BottomSheets.displayErrorModal(context,
                  title: "Logged Out",
                  message:
                      "your session timed out due to inactivity. Please re-login to continue",
                  onClick: () {
                Navigator.of(context).pop();
                _startFingerPrintLoginProcess();
              });
            });
      });
    } else if (reason.second == SessionTimeoutReason.LOGIN_REQUESTED &&
        !_alreadyInSessionError) {
      _alreadyInSessionError = true;
      UserInstance().resetSession();
      Future.delayed(Duration(milliseconds: 150), () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return BottomSheets.displayErrorModal(context,
                  title: "Logged Out",
                  message: "A Re-Login was needed for you to continue",
                  onClick: () {
                Navigator.of(context).pop();
                _startFingerPrintLoginProcess();
              });
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final minHeight = MediaQuery.of(context).size.height;

    Provider.of<LoginViewModel>(context, listen: false);

    final sessionReason = ModalRoute.of(context)!.settings.arguments
        as Tuple<String, SessionTimeoutReason>?;
    _onSessionReason(sessionReason);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(Routes.SIGN_UP);
        return true;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        // backgroundColor: Colors.backgroundWhite,
        body: SingleChildScrollView(
          child: Container(
            height: minHeight, //TODO: Find out what this means here
            child: Stack(
              children: [
                _buildTopMenu(),
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.37,
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 16, right: 16, top: 34, bottom: 0),
                        child: _buildCenterBox(context),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SlideTransition(
                        position: _ussdOffsetAnimation,
                        child: _bottomUSSDWidget(),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment(0, -0.30),
                  child: SvgPicture.asset(
                    "res/drawables/m_icon_2.svg",
                    height: 110,
                    width: 110,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }
}
