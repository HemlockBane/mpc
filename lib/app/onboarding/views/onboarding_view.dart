import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

///@author Paul Okeke
class OnBoardingScreen extends StatelessWidget {

  Widget _buildButton({required String title, required String imageRes, required VoidCallback? onClick}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.primaryColor.withOpacity(0.1),
          elevation: 8,
        ),
        onPressed: onClick,
        child: Container(
          padding: EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 19),
          child: Column(
            children: [
              SvgPicture.asset(imageRes, width: 110, height: 110,),
              SizedBox(height: 15),
              Text(
                  title,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.colorPrimaryDark,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.4
                  ),
                  textAlign: TextAlign.center
              ),
              SizedBox(height: 6,),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    PreferenceUtil.deleteLoggedInUser();

    return Scaffold(
      appBar: AppBar(elevation: 0),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 36),
        color: Colors.primaryColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 60,
            ),
            Flexible(flex:0,child: Text(
              'Getting started \nwith Moniepoint',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28
              ),
            )),
            SizedBox(height: 67 +40),
            Expanded(flex:0,child: Row(
              // mainAxisAlignment: MainAxisAlignment.s,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: _buildButton(
                        title: 'I don’t have a\nMoniepoint Account',
                        imageRes: 'res/drawables/ic_has_no_account.svg',
                        onClick: () => Future.delayed(Duration(milliseconds: 520), () {
                          Navigator.of(context).pushNamed(Routes.REGISTER_NEW_ACCOUNT);
                        })
                    ),
                    flex: 1,
                    fit: FlexFit.tight,
                  ),
                  SizedBox(width: 18),
                  Flexible(
                    child: _buildButton(
                        title: 'I have a Moniepoint\nAccount',
                        imageRes: 'res/drawables/ic_has_account.svg',
                        onClick: () => Future.delayed(Duration(milliseconds: 520), () {
                          Navigator.of(context).pushNamed(Routes.REGISTER_EXISTING_ACCOUNT);
                        })
                    ),
                    flex: 1,
                    fit: FlexFit.tight,
                  ),
                ]
            )),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: 'Already have a profile? ',
                      style: TextStyle(fontFamily: Styles.defaultFont, fontSize: 16),
                      children: [
                        TextSpan(
                            text: 'Login',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).popAndPushNamed('/login')
                        )
                      ]
                  )
              ),
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
