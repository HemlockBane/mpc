import 'package:flutter/material.dart';

class PopUpNotificationRoute<T> extends PopupRoute<T> {



  @override
  Color? get barrierColor => Colors.black.withOpacity(0.7);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "test";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    throw UnimplementedError();
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);
}