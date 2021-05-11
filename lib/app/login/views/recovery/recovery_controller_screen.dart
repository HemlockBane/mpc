import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recover_password_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recover_username_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_otp_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_set_password_view.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_security_question_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:provider/provider.dart';

enum RecoveryMode {
  USERNAME_RECOVERY, PASSWORD_RECOVERY, DEVICE
}

class RecoveryControllerScreen extends StatefulWidget {

  final _navigatorKey = GlobalKey<NavigatorState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  RecoveryControllerScreen();

  @override
  State<StatefulWidget> createState() {
    return _RecoveryControllerScreen();
  }
}

class _RecoveryControllerScreen extends State<RecoveryControllerScreen> {
  late RecoveryMode mode;

  Route _generateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case "username":
        page = RecoverUsernameScreen(widget._scaffoldKey);
        break;
      case "password":
        page = RecoverPasswordScreen(widget._scaffoldKey);
        break;
      case "security_question":
        page = SecurityQuestionScreen(widget._scaffoldKey, this.mode);
        break;
      case "recovery_otp":
        page = RecoveryOtpView(widget._scaffoldKey);
        break;
      case "set_password":
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
    if(mode == RecoveryMode.USERNAME_RECOVERY) return "username";
    if(mode == RecoveryMode.PASSWORD_RECOVERY) return "password";
    if(mode == RecoveryMode.DEVICE) return "security_question";
    return "username";
  }

  @override
  Widget build(BuildContext context) {
    this.mode = ModalRoute.of(context)!.settings.arguments as RecoveryMode;

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: RecoveryViewModel())],
      child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            key: widget._scaffoldKey,
            appBar: AppBar(
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
  
}