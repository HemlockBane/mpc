import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/details_collection_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/new_account_otp_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/verify_phone_number_otp_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/views/phone_number_validation_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:provider/provider.dart';

class NewAccountScreen extends StatelessWidget  {
  static const OTP_SCREEN = "otp-screen";
  static const COLLECTION_SCREEN = "media-collection-screen";
  static const ONBOARDING_PHONE_NUMBER_VALIDATION  = "ONBOARDING_PHONE_NUMBER_VALIDATION";
  static const ONBOARDING_PHONE_NUMBER_VERIFICATION  = "ONBOARDING_PHONE_NUMBER_VERIFICATION";

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
      case OTP_SCREEN:
        page = NewAccountOTPScreen(_scaffoldKey);
        break;
      case COLLECTION_SCREEN:
        page = DetailCollectionScreen(_scaffoldKey);
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
        providers: [ChangeNotifierProvider.value(value: OnBoardingViewModel())],
        child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.backgroundWhite,
                iconTheme: IconThemeData(color: Colors.primaryColor)
            ),
            body: Navigator(
              key: _navigatorKey,
              initialRoute: ONBOARDING_PHONE_NUMBER_VALIDATION,
              onGenerateRoute: _generateRoute,
            ),
          ),
        ));
  }
}