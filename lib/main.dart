import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' hide Colors, Card;
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/di/service_module.dart';
import 'package:moniepoint_flutter/core/di/db_module.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/work/work_dispatcher.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';
import 'app/moniepoint_application.dart';
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
  Workmanager().initialize(workDispatcher, isInDebugMode: false);

  await BiometricHelper.initialize(
      keyFileName: "moniepoint_iv",
      keyStoreName: "AndroidKeyStore",
      keyAlias: "teamapt-moniepoint"
  );

  await injectDependencies();

  await Firebase.initializeApp();
  await PreferenceUtil.initAsync();
  MixpanelManager.initAsync();

  AppNotificationService().initialize();
}

Future<void> injectDependencies() async {
  await DatabaseModule.inject();
  ServiceModule.inject();
}
  