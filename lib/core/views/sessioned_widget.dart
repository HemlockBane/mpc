
import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/main.dart';

import '../routes.dart';
import '../timeout_reason.dart';
import '../tuple.dart';

typedef SessionEventCallback<T extends SessionTimeoutReason> = Function(T value);

class SessionedWidget extends GestureDetector {

  final BuildContext context;

  SessionedWidget({required this.context, Widget? child}) : super(child: child) {
    UserInstance().updateSessionEventCallback(_onSessionTimeOut);
    UserInstance().startSession(context);
  }

  void _onSessionTimeOut(SessionTimeoutReason reason) {
    print("Attempting to auto logout");
    if(navigatorKey.currentState?.canPop() == true) {
      navigatorKey.currentState?.pop();
    }
    UserInstance().resetSession();
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
        Routes.LOGIN, (route) => false,
        arguments: Tuple("reason", reason)
    );
  }

  @override
  HitTestBehavior? get behavior => HitTestBehavior.translucent;

  @override
  GestureTapCallback? get onTap => () => UserInstance().updateLastActivityTime();

  @override
  GestureDragDownCallback? get onPanDown => (a) =>  UserInstance().updateLastActivityTime();

}