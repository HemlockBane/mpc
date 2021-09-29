
import 'package:flutter/material.dart';

class GestureAbsorberRoute<T> extends PopupRoute<T>{
  GestureAbsorberRoute({this.isDismissible = false, this.modalBarrierColor});

  final Color? modalBarrierColor;
  final bool isDismissible;

  @override
  Color? get barrierColor => modalBarrierColor ?? Colors.black;

  @override
  bool get barrierDismissible => isDismissible;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => Duration(milliseconds: 250);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return Container();
  }

}

void showGestureAbsorberRoute({required BuildContext context}){
  Navigator.of(context).push(GestureAbsorberRoute(modalBarrierColor: Colors.transparent));
}

void hideGestureAbsorberRoute({required BuildContext context}){
  Navigator.of(context).pop();
}