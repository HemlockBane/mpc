
import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';

class SessionedWidget extends GestureDetector {

  final BuildContext context;

  SessionedWidget({required this.context, Widget? child}) : super(child: child) {
    UserInstance().startSession(context);
  }

  @override
  HitTestBehavior? get behavior => HitTestBehavior.translucent;

  @override
  GestureTapCallback? get onTap => () => UserInstance().startSession(context);

  @override
  GestureDragDownCallback? get onPanDown => (a) =>  UserInstance().startSession(context);

}