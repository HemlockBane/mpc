import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_view.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_view.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/onboarding/introduction_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/existing_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/liveliness_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/new_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/onboarding_view.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/di/db_module.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:provider/provider.dart';

void main() {
  DatabaseModule.inject();
  ServiceModule.inject();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => DashboardViewModel()),
    ],
    child: MoniepointApp(),
  ));
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
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
    PreferenceUtil.init();
    return MaterialApp(
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      home: Scaffold(
        body: OnBoardingScreen(),
      ),
      //TODO consider moving this to a separate file
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context) => Scaffold(body: LoginScreen()),
        '/sign-up': (BuildContext context) => Scaffold(body: OnBoardingScreen()),
        Routes.REGISTER_EXISTING_ACCOUNT: (BuildContext context) => Scaffold(body: ExistingAccountView()),
        Routes.REGISTER_NEW_ACCOUNT: (BuildContext context) => Scaffold(body: NewAccountScreen()),
        Routes.ACCOUNT_RECOVERY: (BuildContext context) => Scaffold(body: RecoveryControllerScreen()),
        Routes.DASHBOARD: (BuildContext context) => Scaffold(body: DashboardScreen()),
        Routes.ACCOUNT_UPDATE: (BuildContext context) => Scaffold(body: AccountUpdateScreen()),
        Routes.LIVELINESS: (BuildContext context) => Scaffold(body: LivelinessScreen()),
        Routes.TRANSFER: (BuildContext context) => TransferScreen(),
      },
    );
  }
}
