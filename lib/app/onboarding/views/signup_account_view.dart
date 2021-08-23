import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/enter_bvn_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/views/verify_phone_number_otp_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/views/profile_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';
import 'account_info_view.dart';
import 'phone_number_validation_view.dart';

class SignUpAccountScreen extends StatelessWidget  {
  static const OTP_SCREEN = "otp-screen";
  static const COLLECTION_SCREEN = "media-collection-screen";
  static const ONBOARDING_PHONE_NUMBER_VALIDATION = "ONBOARDING_PHONE_NUMBER_VALIDATION";
  static const ONBOARDING_PHONE_NUMBER_VERIFICATION = "ONBOARDING_PHONE_NUMBER_VERIFICATION";
  static const ONBOARDING_ENTER_BVN  = "ONBOARDING_ENTER_BVN";
  static const ACCOUNT_INFO = "ACCOUNT_INFO";
  static const PROFILE = "PROFILE";

  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case ONBOARDING_PHONE_NUMBER_VALIDATION:
        page = PhoneNumberValidationScreen(_scaffoldKey);
        break;
      case ONBOARDING_PHONE_NUMBER_VERIFICATION:
        page = VerifyPhoneNumberOTPScreen(_scaffoldKey);
        break;
      case ONBOARDING_ENTER_BVN:
        page = EnterBVNScreen(_scaffoldKey);
        break;
      case ACCOUNT_INFO:
        page = AccountInfoScreen(_scaffoldKey);
        break;
      case PROFILE:
        page = ProfileScreen(_scaffoldKey);
        break;
    }

    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  Future<bool> _onBackPressed() async {
    final isPop = await _navigatorKey.currentState?.maybePop();
    return (isPop != null && isPop) ? Future.value(false) : Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => OnBoardingViewModel()),],
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: AppBar(
              titleSpacing: -10,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  final canPop = await _onBackPressed();
                  print("OnPressedValue is $canPop");
                  if(canPop) {
                    SystemNavigator.pop();
                  }
                },
              ),
              title: Text(
                  "Getting Started",
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontFamily: Styles.defaultFont,
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                  )
              ),
              elevation: 0,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.primaryColor)
          ),
          body: Navigator(
            key: _navigatorKey,
            initialRoute: ONBOARDING_PHONE_NUMBER_VALIDATION,
            onGenerateRoute: _generateRoute,
          ),
        ),
      ),
    );
  }
}