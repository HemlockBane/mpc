
import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/login/views/login_response_observer.dart';
import 'package:moniepoint_flutter/app/notifications/view/notification_route_observer.dart';
import 'package:moniepoint_flutter/app/onboarding/views/welcome_screen.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import 'login/viewmodels/login_view_model.dart';
import 'login/views/login_view.dart';

///
///@author Paul Okeke
///
class MoniepointApp extends StatelessWidget with CompositeDisposableWidget {
  @override
  Widget build(BuildContext context) {
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

  Future<Widget> _mainBody() async {
    String? savedUsername = PreferenceUtil.getSavedUsername();

    if(savedUsername == null || savedUsername.isEmpty) return WelcomeScreen();

    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final biometricHelper = BiometricHelper.getInstance();
    final canLoginWithBiometric = await loginViewModel.canLoginWithBiometric(biometricHelper);

    if(canLoginWithBiometric) {
      final LoginResponseObserver responseObserver = LoginResponseObserver(
          context: context,
          viewModel: loginViewModel
      );
      return BiometricLoginButton.getBiometricLoginScreen(loginViewModel, responseObserver);
    }

    return LoginView();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      restorationScopeId: "root",
      title: 'Moniepoint Customers',
      theme: defaultAppTheme,
      navigatorKey: navigatorKey,
      navigatorObservers: [NotificationRouteObserver()],
      home: Scaffold(
          body: FutureBuilder(
              future: _mainBody(),
              builder: (ctx, AsyncSnapshot<Widget> value) {
                return value.connectionState != ConnectionState.done
                    ? SizedBox.shrink()
                    : value.data!;
              }
          )
      ),
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

