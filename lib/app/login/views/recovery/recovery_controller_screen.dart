import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recover_password_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recover_username_bvn_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recover_username_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_otp_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_set_password_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/username_display_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:provider/provider.dart';

enum RecoveryMode {
  USERNAME_RECOVERY, PASSWORD_RECOVERY, DEVICE
}

class RecoveryControllerScreen extends StatefulWidget {

  static const String USERNAME_SCREEN = "username";
  static const String USERNAME_BVN_SCREEN = "USERNAME_BVN_SCREEN";
  static const String USERNAME_DISPLAY_SCREEN = "USERNAME_DISPLAY_SCREEN";
  static const String RECOVERY_OTP = "recovery_otp";
  static const String SET_PASSWORD = "SET_PASSWORD";

  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  RecoveryControllerScreen();

  @override
  State<StatefulWidget> createState() {
    return _RecoveryControllerScreen();
  }
}

class _RecoveryControllerScreen extends State<RecoveryControllerScreen> with RestorationMixin {
  late RecoveryMode mode;

  final viewModel = RecoveryViewModel();
  final RestorableString _index = RestorableString("");

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case RecoveryControllerScreen.USERNAME_SCREEN:
        page = RecoverUsernameScreen(widget._scaffoldKey);
        break;
      case RecoveryControllerScreen.USERNAME_BVN_SCREEN:
        page = RecoverUsernameBVNScreen(widget._scaffoldKey);
        break;
      case RecoveryControllerScreen.USERNAME_DISPLAY_SCREEN:
        page = UsernameDisplayScreen(widget._scaffoldKey, settings.arguments as String);
        break;
      case "password":
        page = RecoverPasswordScreen(widget._scaffoldKey);
        break;
      case "recovery_otp":
        if(viewModel.recoveryMode == null) viewModel.setRecoveryMode(mode);
        page = RecoveryOtpView(widget._scaffoldKey);
        break;
      case RecoveryControllerScreen.SET_PASSWORD:
        page = SetPasswordRecoveryView(widget._scaffoldKey);
        break;
    }

    return MaterialPageRoute(builder: (context) => page, settings: settings);
  }

  Future<bool> _onBackPressed() async {
    final isPop = await widget._navigatorKey.currentState?.maybePop();
    return (isPop != null && isPop) ? Future.value(false) : Future.value(true);
  }

  String determineInitialRoute(RecoveryMode mode) {
    if(mode == RecoveryMode.USERNAME_RECOVERY) {
      _index.value = describeEnum(RecoveryMode.USERNAME_RECOVERY);
      return "username";
    }
    if(mode == RecoveryMode.PASSWORD_RECOVERY) {
      _index.value = describeEnum(RecoveryMode.PASSWORD_RECOVERY);
      return "password";
    }
    if(mode == RecoveryMode.DEVICE) return RecoveryControllerScreen.RECOVERY_OTP;
    return "username";
  }

  @override
  Widget build(BuildContext context) {
    this.mode = ModalRoute.of(context)!.settings.arguments as RecoveryMode;

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: viewModel)],
      child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            backgroundColor: Colors.white,
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            key: widget._scaffoldKey,
            appBar: AppBar(
                centerTitle: false,
                titleSpacing: -3,
                title: Text(
                  mode == RecoveryMode.USERNAME_RECOVERY ? 'Recover Username' : "Recover Password",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.textColorBlack
                ),),
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.primaryColor)
            ),
            body: Navigator(
              key: widget._navigatorKey,
              initialRoute: determineInitialRoute(mode),
              onGenerateRoute: _generateRoute,
            ),
          ),
        ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  String? get restorationId => "account_recovery";

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_index, "account_recovery_route");
  }
  
}