import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';



class InterestRateBanner extends StatelessWidget {
  const InterestRateBanner({
    Key? key,
    required this.title,
    required this.interestRate,
    required this.subtitle,
    this.bannerColor,
  }) : super(key: key);

  final String title;
  final String interestRate;
  final String subtitle;
  final String? bannerColor;

  TextStyle getBoldStyle(
    {double fontSize = 32.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700}) =>
    TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            title,
            style: getBoldStyle(fontSize: 16.8, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(interestRate, style: getBoldStyle(fontSize: 38)),
              SizedBox(width: 2),
              Text("%",
                style: getBoldStyle(
                  fontSize: 26,
                  color: Colors.textColorBlack.withOpacity(0.5))),
            ],
          ),
          SizedBox(height: 3),
          Text(
            subtitle.toUpperCase(),
            style: TextStyle(
              color: Colors.textColorBlack,
              fontWeight: FontWeight.normal,
              fontSize: 10,
              letterSpacing: 4.5),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.peach,
        borderRadius: BorderRadius.all(Radius.circular(16))),
    );
  }
}