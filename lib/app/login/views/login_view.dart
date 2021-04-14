import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/dialogs/recover_credentials.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  Widget makeTextWithIcon(
      {required String src,
      required String text,
      VoidCallback? onClick,
      double spacing = 4}) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            src,
            fit: BoxFit.contain,
          ),
          SizedBox(height: spacing),
          Text(text,
              style: TextStyle(
                  fontFamily: 'CircularStd',
                  fontSize: 16,
                  color: Colors.textColorDeem))
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
            onClick: () => {print('Support')}),
        SizedBox(width: 18),
        makeTextWithIcon(
            text: "Branches",
            spacing: 0.2,
            src: "res/drawables/double_location_icon.svg",
            onClick: () => {})
      ],
    );
  }

  Widget _buildCenterBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Welcome Back',
            style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.w700,
                fontSize: 23)),
        SizedBox(height: 25),
        _buildLoginBox(context)
      ],
    );
  }

  Widget _buildLoginBox(BuildContext context) {
    return Card(
      elevation: 30,
      shadowColor: Colors.cardBorder.withOpacity(0.09),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side:
              BorderSide(color: Colors.cardBorder.withOpacity(0.05), width: 1)),
      child: Padding(
        padding: EdgeInsets.only(top: 25, left: 16, right: 16, bottom: 18),
        child: Column(
          children: [
            Styles.appEditText(
                hint: 'Username',
                animateHint: true,
                drawablePadding: 4,
                startIcon: Icon(CustomFont.username_icon, color: Colors.colorFaded),
                focusListener: (bool) => this.setState(() {})),
            SizedBox(height: 16),
            Styles.appEditText(
                hint: 'Password',
                animateHint: true,
                drawablePadding: 4,
                startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                focusListener: (bool) => this.setState(() {}),
                isPassword: true),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Styles.appButton(
                paddingTop: 20,
                paddingBottom: 20,
                  onClick: () => {}, text: 'Login', elevation: 8),
            ),
            SizedBox(height: 24),
            Divider(color: Colors.colorFaded.withOpacity(0.9), height: 3),
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
                              content: RecoverCredentialsDialogLayout.getLayout()
                          );
                        });
                  },
                  child: Text('Recover Credentials'),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.all(0)),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.primaryColor),
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
    return Card(
      elevation: 0,
      shadowColor: Colors.cardBorder.withOpacity(0.09),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          side: BorderSide(color: Colors.cardBorder.withOpacity(0.05), width: 1)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
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
                Text('Transfer, Airtime & Pay Bills Offline!',
                    style: TextStyle(
                        fontFamily: Styles.defaultFont,
                        color: Colors.textSubColor.withOpacity(0.6))),
              ],
            ),
            Text('*7849#',
                style: TextStyle(
                    fontFamily: Styles.defaultFont,
                    fontSize: 25,
                    color: Colors.primaryColor,
                    fontWeight: FontWeight.bold)
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
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Container(
                  color: Colors.backgroundWhite,
                  padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
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
                    Flexible(
                      child: _bottomUSSDWidget(),
                      fit: FlexFit.loose,
                      flex: 0,
                    ),
                  ]),
                )
            )
        )
    );
  }
}
