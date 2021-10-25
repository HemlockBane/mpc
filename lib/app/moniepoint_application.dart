import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/notifications/view/notification_route_observer.dart';
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
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom]);
    }
    return MoniepointAppMessenger(child: _MoniepointAppContainer());
  }
}

///_MoniepointAppContainer
///
///
class _MoniepointAppContainer extends StatefulWidget {

  _MoniepointAppContainer({Key? key}): super(key:  key);

  @override
  State<StatefulWidget> createState() => _MoniepointAppContainerState();
}

class _MoniepointAppContainerState extends State<_MoniepointAppContainer> with CompositeDisposableWidget {

  late final SystemConfigurationViewModel _viewModel;

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
  void initState() {
    this._viewModel = Provider.of<SystemConfigurationViewModel>(context, listen: false);
    _loadSystemConfigurations(_viewModel);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? savedUsername = PreferenceUtil.getSavedUsername();

    Widget body = (savedUsername == null || savedUsername.isEmpty) ? SignUpAccountScreen() : LoginScreen();

    return MaterialApp(
      restorationScopeId: "root",
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        routeObserver, NotificationRouteObserver()
      ],
      home: Scaffold(body: body),
      onGenerateRoute: Routes.generateRouteWithSettings,
      routes: Routes.buildRouteMap(_viewModel),
    );
  }

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }
}

///MoniepointAppMessenger
///
///
class MoniepointAppMessenger extends StatefulWidget {

  MoniepointAppMessenger({required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => MoniepointAppMessengerState();

  static MoniepointAppMessengerState of(BuildContext context) {
    final _MoniepointAppMessengerScope scope = context
        .dependOnInheritedWidgetOfExactType<_MoniepointAppMessengerScope>()!;
    return scope.moniepointAppMessengerState;
  }
}

class MoniepointAppMessengerState extends State<MoniepointAppMessenger> {

  @override
  Widget build(BuildContext context) {
    return _MoniepointAppMessengerScope(
      child: widget.child,
      moniepointAppMessengerState: this,
    );
  }

}

class _MoniepointAppMessengerScope extends InheritedWidget {
  _MoniepointAppMessengerScope({
    Key? key,
    required Widget child,
    required this.moniepointAppMessengerState
  }) : super(key: key, child: child);

  final MoniepointAppMessengerState moniepointAppMessengerState;

  @override
  bool updateShouldNotify(_MoniepointAppMessengerScope old) =>
      moniepointAppMessengerState != old.moniepointAppMessengerState;
}
