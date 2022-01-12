import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

///@author Paul Okeke
///

class WelcomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.primaryColor.withOpacity(0.6),
      body: Container(
        padding: EdgeInsets.only(top: 64, left: 21, right: 21, bottom: 46),
        decoration: BoxDecoration(
            color: Colors.primaryColor,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("res/drawables/ic_app_new_bg.png")
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("res/drawables/ic_m_2.svg"),
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
            ),
            Spacer(),
            Text(
              "Welcome to\nStress-free Banking",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Styles.appButton(
                elevation: 0.2,
                buttonStyle: Styles.whiteButtonStyle.copyWith(
                  textStyle: MaterialStateProperty.all(TextStyle(
                      fontSize: 14,
                      color: Colors.primaryColor,
                      fontWeight: FontWeight.w500
                  ))
                ),
                text: "Create Account",
                onClick: () => Navigator.of(context).pushNamed(Routes.SIGN_UP),
              ),
            ),
            SizedBox(height: 24,),
            SizedBox(
              width: double.infinity,
              child: Styles.appButton(
                elevation: 0.2,
                buttonStyle: Styles.primaryDarkButtonStyle.copyWith(
                  textStyle: MaterialStateProperty.all(TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ))
                ),
                text: "Login",
                onClick: () => Navigator.of(context).pushNamed(Routes.LOGIN),
              ),
            ),
          ],
        ),
      ),
    );
  }

}