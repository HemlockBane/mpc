
import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/main.dart';
import '../routes.dart';
import '../timeout_reason.dart';
import '../tuple.dart';

///@author Paul Okeke

typedef SessionEventCallback<T extends SessionTimeoutReason> = Function(T value);

class SessionedWidget extends GestureDetector {

  final BuildContext context;
  final int sessionTime;

  SessionedWidget({required this.context, Widget? child, this.sessionTime = 120}) : super(child: child) {
    UserInstance().updateSessionEventCallback(_onSessionTimeOut);
    UserInstance().startSession(context, sessionTime: sessionTime);
  }

  void _onSessionTimeOut(SessionTimeoutReason reason) {
    if(UserInstance().getUser() == null) return;

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