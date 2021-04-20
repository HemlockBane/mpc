import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/onboarding/introduction_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/existing_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/new_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/onboarding_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/routes.dart';

void main() {
  ServiceModule.initService();
  runApp(MoniepointApp());
}

//We need to move this to some where else
final defaultAppTheme = ThemeData(
    disabledColor: Colors.primaryColor.withOpacity(0.5),
    primaryColor: Colors.primaryColor,
    backgroundColor: Colors.backgroundWhite,
    fontFamily: "CircularStd",
    textTheme: TextTheme());

class MoniepointApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      home: Scaffold(
        body: IntroductionScreen(),
      ),
      //TODO consider moving this to a separate file
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Scaffold(body: LoginScreen()),
        '/sign-up': (BuildContext context) => Scaffold(body: OnBoardingScreen()),
        Routes.REGISTER_EXISTING_ACCOUNT: (BuildContext context) => Scaffold(body: ExistingAccountView()),
        Routes.REGISTER_NEW_ACCOUNT: (BuildContext context) => Scaffold(body: NewAccountScreen()),
      },
    );
  }
}
