import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';


class LoanConfirmationDetailTile extends StatelessWidget {
  const LoanConfirmationDetailTile(
    {Key? key, required this.title, required this.subtitle, this.horizontalPadding})
    : super(key: key);

  final String title;
  final String subtitle;
  final double? horizontalPadding;

  TextStyle getBoldStyle({
    double fontSize = 19.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
    TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 14.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
    TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: getNormalStyle()),
          SizedBox(height: 5),
          Text(subtitle, style: getBoldStyle())
        ],
      ),
    );
  }
}