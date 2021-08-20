import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/signup_account_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/di/db_module.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

//We need to move this to some where else


final defaultAppTheme = ThemeData(
    disabledColor: Colors.primaryColor.withOpacity(0.5),
    primaryColor: Colors.primaryColor,
    backgroundColor: Colors.backgroundWhite,
    fontFamily: Styles.defaultFont,
    textTheme: TextTheme(
        bodyText2: TextStyle(
            fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"])));

class MoniepointApp extends StatelessWidget {
  // This widget is the root of your application
  void _loadSystemConfigurations(SystemConfigurationViewModel viewModel) {
    Rx.combineLatest2(
        viewModel.getSystemConfigurations(),
        viewModel.getUSSDConfiguration(), (a, b) {}
    ).listen((event) {
      print("Fetching System Configuration!!!");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }

    final systemConfigViewModel = SystemConfigurationViewModel();
    _loadSystemConfigurations(systemConfigViewModel);

    String? savedUsername = PreferenceUtil.getSavedUsername();
    return MaterialApp(
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      home: Scaffold(
        body: (savedUsername == null || savedUsername.isEmpty)
            ? SignUpAccountScreen()
            : LoginScreen(),
      ),
      onGenerateRoute: Routes.generateRouteWithSettings,
      routes: Routes.buildRouteMap(systemConfigViewModel),
    );
  }
}

void main() async {
  await _onCreate();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginViewModel()),
      ChangeNotifierProvider(create: (_) => DashboardViewModel()),
    ],
    child: MoniepointApp(),
  ));
}

Future<void> _onCreate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseModule.inject();
  ServiceModule.inject();

  await Firebase.initializeApp();
  await PreferenceUtil.initAsync();
}
