import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/model/data/security_flag.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/recover_credentials.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/unrecognized_device_dialog.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'recovery/recovery_controller_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    _usernameController.addListener(() {
      validateForm();
    });

    _passwordController.addListener(() {
      validateForm();
    });
    super.initState();
  }

  void validateForm() {
    setState(() {
      _isFormValid = _usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty;
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
                  fontFamily: 'CircularStd',
                  fontSize: 12,
                  color: Colors.textColorDeem
              ))
        ],
      ),
      onTap: onClick,
    );
  }

  Widget _buildTopMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        makeTextWithIcon(
            text: "Support",
            src: "res/drawables/support_icon.svg",
            spacing: 5,
            width: 27,
            height: 24,
            onClick: () => Navigator.of(context).pushNamed(Routes.SUPPORT)
        ),
        SizedBox(width: 18),
        makeTextWithIcon(
            text: "Branches",
            spacing: 0.2,
            width: 24,
            height: 28,
            src: "res/drawables/double_location_icon.svg",
            onClick: () => {})
      ],
    );
  }

  Widget _buildCenterBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Welcome Back',
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                )
            ),
        ),
        SizedBox(height: 24),
        _buildLoginBox(context)
      ],
    );
  }

  void _subscribeUiToLogin(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    String username = _usernameController.text;
    String password = _passwordController.text;

    viewModel.loginWithPassword(username, password).listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<User>) {
        setState(() => _isLoading = false);
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
      if(event is Success<User>) {
        setState(() => _isLoading = false);
        PreferenceUtil.saveLoggedInUser(event.data!);
        PreferenceUtil.saveUsername(event.data?.username ?? "");
        checkSecurityFlags();
      }
    });
  }

  void loginSuccessfully() {
      Navigator.popAndPushNamed(context, Routes.DASHBOARD);
  }

  void checkSecurityFlags() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    var flag = viewModel.securityFlagQueue;
    if(flag?.isEmpty == true) return loginSuccessfully();
    var queue = flag?.removeFirst();

    if (queue == SecurityFlag.ADD_DEVICE) {
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (b) => UnRecognizedDeviceDialog(()=> checkSecurityFlags())
      );
    }
  }

  Widget _buildLoginBox(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.cardBorder.withOpacity(0.15),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.cardBorder.withOpacity(0.05), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 18),
        child: Column(
          children: [
            Styles.appEditText(
                hint: 'Username',
                controller: _usernameController,
                animateHint: true,
                drawablePadding: 4,
                fontSize: 16,
                padding: EdgeInsets.only(top: 22, bottom: 22),
                startIcon: Icon(CustomFont.username_icon, color: Colors.colorFaded, size: 28,),
                focusListener: (bool) => this.setState(() {})),
            SizedBox(height: 22),
            Styles.appEditText(
                controller: _passwordController,
                hint: 'Password',
                animateHint: true,
                drawablePadding: 4,
                fontSize: 16,
                padding: EdgeInsets.only(top: 22, bottom: 22),
                endIcon: IconButton(
                    icon: Icon(this._isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.colorFaded),
                    onPressed: () {
                      setState(() {
                        this._isPasswordVisible = !_isPasswordVisible;
                      });
                    }
                ),
                startIcon: Icon(CustomFont.password, color: Colors.colorFaded, size: 25,),
                focusListener: (bool) => this.setState(() {}),
                isPassword: !_isPasswordVisible
            ),
            SizedBox(height: 22),
            Styles.statefulButton2(
                isValid: _isFormValid,
                padding: 20,
                elevation: _isFormValid && !_isLoading ? 4 : 0,
                onClick: () => _subscribeUiToLogin(context),
                text: "Login",
                isLoading: _isLoading
            ),
            SizedBox(height: 28),
            Divider(color: Colors.colorFaded.withOpacity(0.9), height: 1, thickness: 0.4,),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      isScrollControlled: false,
                        context: context,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return BottomSheets.makeAppBottomSheet(
                              height: MediaQuery.of(context).size.height * 0.45,//this is like our guideline
                              centerImageRes: 'res/drawables/ic_key.svg',
                              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                              content: RecoverCredentialsDialogLayout.getLayout(context)
                          );
                        });
                  },
                  child: Text('Recover Credentials'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontFamily: Styles.defaultFont,
                          fontSize: 16,
                          fontWeight: FontWeight.bold))),
                ),
                TextButton(
                  onPressed: () => {},
                  child: Text('Login Options'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
                      textStyle: MaterialStateProperty.all(TextStyle(
                          fontFamily: Styles.defaultFont,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)
                      )
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _bottomUSSDWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          border: Border.all(color: Colors.cardBorder.withOpacity(0.05), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.cardBorder.withOpacity(0.2),
              offset: Offset(0, 8),
              blurRadius: 6
            )
          ]
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(child: Column(
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
                SizedBox(height: 5,),
                Text('Transfer, Airtime & Pay Bills Offline!',
                    style: TextStyle(
                        fontFamily: Styles.defaultFont,
                        color: Colors.textSubColor.withOpacity(0.6))),
              ],
            )),
            SizedBox(width: 8,),
            Text('*7849#',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final minHeight = MediaQuery.of(context).size.height - (top + 34);

    Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
        body: ScrollView(
            child: Container(
              color: Colors.backgroundWhite,
              padding: EdgeInsets.only(left: 16, right: 16, top: 64, bottom: 0),
              height: minHeight,
              child: Column(children: [
                Flexible(
                  child: _buildTopMenu(),
                  fit: FlexFit.loose,
                  flex: 1,
                ),
                Flexible(
                  child: _buildCenterBox(context),
                  fit: FlexFit.tight,
                  flex: 3,
                ),
                Expanded(
                  flex: 0,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: _bottomUSSDWidget(),
                  ),
                ),
              ]),
            )
        )
    );
  }
}
