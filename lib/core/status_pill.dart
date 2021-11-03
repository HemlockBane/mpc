import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    Key? key,
    required this.statusDescription,
    required this.statusColor,
  }) : super(key: key);

  final Color statusColor;
  final String statusDescription;

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) => TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        statusDescription,
        style: getBoldStyle(fontSize: 10, color: statusColor),
      ),
      padding: EdgeInsets.fromLTRB(12, 5, 10, 5),
      decoration: BoxDecoration(
          color: statusColor.withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(7.5))),
    );
  }
}
