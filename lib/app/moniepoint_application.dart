import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import 'login/views/login_view.dart';
import 'onboarding/views/signup_account_view.dart';

class MoniepointApp extends StatelessWidget with CompositeDisposableWidget {
  // This widget is the root of your application
  void _loadSystemConfigurations(SystemConfigurationViewModel viewModel) {
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
