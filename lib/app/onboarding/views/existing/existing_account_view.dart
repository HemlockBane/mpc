import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/account_number_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/confirm_account_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/existing/existing_account_otp_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/profile_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:provider/provider.dart';

/// This class serves as the controller for screens required for
/// registering an existing account
class ExistingAccountView extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "account-number":
        page = EnterAccountNumberScreen(_scaffoldKey);
        break;
      case "confirm-account":
        page = ConfirmAccountNumberScreen(_scaffoldKey);
        break;
      case "otp-screen":
        page = ExistingAccountOTPScreen(_scaffoldKey);
        break;
      case "profile":
        page = ProfileScreen(_scaffoldKey);
        break;
    }
    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  Future<bool> _onBackPressed() async {
    final isPop = await _navigatorKey.currentState?.maybePop();
    return (isPop!=null && isPop) ? Future.value(false) : Future.value(true);
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
                iconTheme: IconThemeData(color: Colors.primaryColor)),
            body: Navigator(
              key: _navigatorKey,
              initialRoute: "account-number",
              onGenerateRoute: _generateRoute,
            ),
          ),
        ));
  }
}
