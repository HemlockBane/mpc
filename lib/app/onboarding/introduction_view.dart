import 'package:flutter/material.dart' hide Colors;
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';

/// The Introduction Screen where users decide either to login or sign-up
/// @author Paul Okeke
class IntroductionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: Color(0XFF055ee9)),
          SvgPicture.asset(
            'res/drawables/introduction_bg.svg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Container(
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 300),
                    SvgPicture.asset('res/drawables/app_icon.svg'),
                    SizedBox(height: 16),
                    SvgPicture.asset('res/drawables/app_name.svg'),
                    Spacer(flex: 1),
                    SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          text: "Sign up",
                          buttonStyle: Styles.whiteButtonStyle,
                          onClick: () => Navigator.of(context).pushNamed('/sign-up')),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          text: "Login",
                          buttonStyle: Styles.primaryDarkButtonStyle,
                          onClick: () => Navigator.of(context).pushNamed('/login')),
                    ),
                    SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
