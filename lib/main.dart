import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/login_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/signup_account_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/di/db_module.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/work/ios_background_task_worker.dart';
import 'package:moniepoint_flutter/core/work/work_dispatcher.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:workmanager/workmanager.dart';

import 'app/notifications/app_notification_service.dart';
import 'core/utils/biometric_helper.dart';


//We need to move this to some where else

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();

final defaultAppTheme = ThemeData(
    disabledColor: Colors.primaryColor.withOpacity(0.5),
    primaryColor: Colors.primaryColor,
    backgroundColor: Colors.backgroundWhite,
    fontFamily: Styles.defaultFont,
    textTheme: TextTheme(
        bodyText2: TextStyle(
            fontFamily: Styles.defaultFont,
            fontFamilyFallback: ["Roboto"]
        )
    )
);

class MoniepointApp extends StatelessWidget with CompositeDisposableWidget {
  // This widget is the root of your application
  void _loadSystemConfigurations(SystemConfigurationViewModel viewModel) {
    Workmanager().initialize(workDispatcher, isInDebugMode: true);
    Rx.combineLatest2(
        viewModel.getSystemConfigurations(),
        viewModel.getUSSDConfiguration(), (a, b) {}
    ).listen((event) {
      print("Fetching System Configuration!!!");
      if(event is Success || event is Error) {
        disposeAll();
      }
    }).disposedBy(this);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    }

    final systemConfigViewModel = Provider.of<SystemConfigurationViewModel>(context, listen: false);
    _loadSystemConfigurations(systemConfigViewModel);

    String? savedUsername = PreferenceUtil.getSavedUsername();
    return MaterialApp(
      restorationScopeId: "root",
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        routeObserver
      ],
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
      ChangeNotifierProvider(create: (_) => SystemConfigurationViewModel()),
    ],
    child: MoniepointApp(),
  ));
}

Future<void> _onCreate() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BiometricHelper.initialize(
      keyFileName: "moniepoint_iv",
      keyStoreName: "AndroidKeyStore",
      keyAlias: "teamapt-moniepoint"
  );
  await DatabaseModule.inject();

  ServiceModule.inject();

  await Firebase.initializeApp();
  await PreferenceUtil.initAsync();
  MixpanelManager.initAsync();

  AppNotificationService().initialize();
}
