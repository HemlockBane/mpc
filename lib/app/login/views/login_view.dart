import 'dart:io';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/login/model/data/security_flag.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/login_options.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/recover_credentials.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
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
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:provider/provider.dart';

import 'dialogs/add_device_dialog.dart';

// import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> with TickerProviderStateMixin {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String savedHashUsername = "";
  String? unHashedUsername = "";

  late final AnimationController _topAnimController;

  late final AnimationController _animController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 2000));

  late final _ussdOffsetAnimation =
      Tween<Offset>(begin: Offset(0, 12), end: Offset(0, 0)).animate(
          CurvedAnimation(parent: _animController, curve: Curves.decelerate));

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isFormValid = false;
  bool _alreadyInSessionError = false;
  bool _isValidated = false;
  BiometricHelper? _biometricHelper;

  CardController controller = CardController();

  @override
  void initState() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);

    viewModel.getSystemConfigurations().listen((event) {});

    _usernameController.addListener(() => validateForm());
    _passwordController.addListener(() => validateForm());

    _topAnimController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();

    _initSavedUsername();
    _animController.forward();
    _initializeAndStartBiometric();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _buildTopMenu(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final Animation<double> sizeBlueBgAnimation =
        Tween<double>(begin: 1, end: 10).animate(
      CurvedAnimation(
        parent: _topAnimController,
        curve: Interval(0.0, 0.1, curve: Curves.elasticInOut),
      ),
    );

    final Animation alignmentLogoAnimation =
        AlignmentTween(begin: Alignment(0, -0.42), end: Alignment(0, 0.0))
            .animate(
      CurvedAnimation(
        parent: _topAnimController,
        curve: Interval(0.11, 0.15, curve: Curves.ease),
      ),
    );

    final Animation<double> opacityLogoAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _topAnimController,
        curve: Interval(
          0.11,
          0.13,
          curve: Curves.ease,
        ),
      ),
    );

    final Animation<double> opacitySpinnerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _topAnimController,
        curve: Interval(
          0.125,
          0.13,
          curve: Curves.ease,
        ),
      ),
    );

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _topAnimController,
          builder: (context, child) {
            return Transform.scale(
              scale: sizeBlueBgAnimation.value,
              child: Container(
                width: width,
                height: height * 0.3,
                child: SvgPicture.asset(
                  "res/drawables/bg.svg",
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
        Container(
          width: width,
          height: height,
          child: SvgPicture.asset(
            "res/drawables/bg_pattern.svg",
            width: width,
            height: height,
            fit: BoxFit.fill,
          ),
        ),
        if (!_isLoading) ...[
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.074, right: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                makeTextWithIcon(
                    text: "Support",
                    src: "res/drawables/ic_support_v2.svg",
                    spacing: 5,
                    width: 25,
                    height: 22,
                    onClick: () =>
                        Navigator.of(context).pushNamed(Routes.SUPPORT)),
                SizedBox(width: 18),
                makeTextWithIcon(
                    text: "Branches",
                    spacing: 0.2,
                    width: 22,
                    height: 26,
                    src: "res/drawables/ic_branches.svg",
                    onClick: () =>
                        Navigator.of(context).pushNamed(Routes.BRANCHES))
              ],
            ),
          ),
        ],
        AnimatedBuilder(
          animation: _topAnimController,
          builder: (context, child) {
            return Stack(
              children: [
                Align(
                  alignment: alignmentLogoAnimation.value,
                  child: Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cardBorder.withOpacity(0.2),
                          offset: Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: alignmentLogoAnimation.value,
                  child: SvgPicture.asset(
                    "res/drawables/ic_m_bg.svg",
                    fit: BoxFit.cover,
                    height: 65,
                    width: 65,
                  ),
                ),
                Opacity(
                  opacity: opacityLogoAnimation.value,
                  child: Align(
                    alignment: Alignment(0, -0.4),
                    child: Container(
                      child: SvgPicture.asset(
                        "res/drawables/ic_m.svg",
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ),
                Opacity(
                  opacity: opacitySpinnerAnimation.value,
                  child: Align(
                    alignment: alignmentLogoAnimation.value,
                    child: Container(
                      child: Lottie.asset(
                        "res/drawables/progress_bar_lottie.json",
                        fit: BoxFit.contain,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _biometricLoginButton() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    return FutureBuilder(
        future: viewModel.canLoginWithBiometric(_biometricHelper),
        builder: (mContext, AsyncSnapshot<bool> snapShot) {
          if (!snapShot.hasData) return SizedBox();
          if (snapShot.hasData && snapShot.data == false) return SizedBox();
          return Row(
            children: [
              SizedBox(
                width: 16,
              ),
              Styles.imageButton(
                  onClick: () => _startFingerPrintLoginProcess(),
                  color: Colors.primaryColor.withOpacity(0.1),
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 14, bottom: 14),
                  image: Platform.isAndroid
                      ? SvgPicture.asset('res/drawables/ic_finger_print.svg')
                      : SvgPicture.asset('res/drawables/ic_login_face.svg'))
            ],
          );
        });
  }

  void _initializeAndStartBiometric() async {
    _biometricHelper = await BiometricHelper.initialize(
        keyFileName: "moniepoint_iv",
        keyStoreName: "AndroidKeyStore",
        keyAlias: "teamapt-moniepoint");
    if (!_alreadyInSessionError) _startFingerPrintLoginProcess();
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

  Widget _buildMidSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Welcome',
            style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.bold,
                fontSize: 24),
          ),
        ),
        // SizedBox(height: 5),
        _buildLoginBox(context),
        Spacer(),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Styles.statefulButton2(
                      isValid: _isFormValid,
                      padding: 20,
                      elevation: _isFormValid && !_isLoading ? 4 : 0,
                      onClick: () => _subscribeUiToLogin(context),
                      text: "Login",
                      isLoading: _isLoading,
                    ),
                  ),
                  _biometricLoginButton()
                ],
              ),
            ],
          ),
        ),
        Spacer(flex: 2),
        SlideTransition(
          position: _ussdOffsetAnimation,
          child: Container(
            margin: EdgeInsets.only(bottom: 0),
            child: _bottomUSSDWidget(),
          ),
        ),
      ],
    );
  }

  void _subscribeUiToLogin(BuildContext context) {
    _topAnimController.forward();
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
      _topAnimController.reset();

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
                openUrl(viewModel.getApplicationPlayStoreUrl());
              }, buttonText: "Upgrade App");
            }
            return BottomSheets.displayErrorModal(context,
                message: event.message);
          });
      _topAnimController.reset();
    }
    if (event is Success<User>) {
      var user = event.data!;

      print("prompts");
      print(user.loginPrompts);

      // if (user.loginPrompts!.isNotEmpty) {
      //   for (var i in user.loginPrompts!) {
      //     print(i.toJson());
      //   }
      // }

      _passwordController.clear();

      PreferenceUtil.setLoginMode(LoginMode.FULL_ACCESS);
      PreferenceUtil.saveLoggedInUser(event.data!);
      PreferenceUtil.saveUsername(event.data?.username ?? "");
      //PreferenceUtil.saveCustomerName(event.data?.customers?.first.name);
      checkSecurityFlags(event.data!);
    }
  }

  Future<void> navigateToDashboardView() async {
    await Navigator.pushReplacementNamed(context, Routes.DASHBOARD);
  }

  void checkSecurityFlags(User user) async {
    if (user.registerDevice == true) {
      _topAnimController.reset();
      setState(() => _isLoading = false);
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (b) => BottomSheets.displayInfoDialog(context,
                  message:
                      "Your login was successful, but this device is not recognized.",
                  title: "Device not recognized",
                  primaryButtonText: "Register Device",
                  secondaryButtonText: "Dismiss", onPrimaryClick: () async {
                Navigator.of(context).popAndPushNamed(Routes.ACCOUNT_RECOVERY,
                    arguments: RecoveryMode.DEVICE);
              }));
    } else {
      navigateToDashboardView();
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
            _topAnimController.forward();
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
          return BottomSheets.makeAppBottomSheet2(
              height: 420,
              dialogIcon: SvgPicture.asset(
                'res/drawables/ic_info_italic.svg',
                color: Colors.primaryColor,
                width: 40,
                height: 40,
              ),
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              centerBackgroundPadding: 15,
              content: RecoverCredentialsDialogLayout.getLayout(context));
        });
  }

  Widget _buildLoginBox(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 16, right: 16, bottom: 0),
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
              focusListener: (bool) => this.setState(() {})),
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
                      color: Colors.textHintColor.withOpacity(0.3)),
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
                        fontWeight: FontWeight.w500))),
              ),
            ],
          ),
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
            Border.all(color: Colors.cardBorder.withOpacity(0.05), width: 0.6),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 4,
            spreadRadius: 1,
            color: Color(0XFF003D9A).withOpacity(0.08),
          )
        ],
      ),
      child: Container(
        margin: EdgeInsets.only(top: 15, bottom: 20),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: InkWell(
            highlightColor: Colors.grey.withOpacity(0.05),
            overlayColor: MaterialStateProperty.all(
                Colors.primaryColor.withOpacity(0.05)),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            onTap: () => openUrl("tel:${codes.first}"),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text('Transfer, Airtime & Pay Bills Offline!',
                            style: TextStyle(
                                fontSize: 11,
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

  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final minHeight = MediaQuery.of(context).size.height;

    // Provider.of<LoginViewModel>(context, listen: false);

    final sessionReason = ModalRoute.of(context)!.settings.arguments
        as Tuple<String, SessionTimeoutReason>?;
    _onSessionReason(sessionReason);

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(Routes.SIGN_UP);
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: minHeight, //TODO: Find out what this means here
            child: Stack(
              children: [
                _buildTopMenu(context),
                if (!_isLoading) ...[
                  Column(
                    children: [
                      SizedBox(
                        height: minHeight * 0.35,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 0, right: 0, top: 34, bottom: 0),
                          child: _buildMidSection(context),
                        ),
                      ),
                      // _buildBottomSection(context),
                    ],
                  )
                ],
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
    _topAnimController.dispose();
    super.dispose();
  }
}
