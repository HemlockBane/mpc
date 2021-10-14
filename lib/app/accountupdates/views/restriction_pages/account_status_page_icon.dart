import 'package:flutter/material.dart';

class AccountStatusPageIcon extends StatelessWidget {

  AccountStatusPageIcon({
    required this.icon,
    required this.color,
    this.padding
  }): super();

  final Widget icon;
  final EdgeInsets? padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      padding: padding ?? EdgeInsets.all(13.5),
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle
      ),
      child: icon,
    );
  }
}