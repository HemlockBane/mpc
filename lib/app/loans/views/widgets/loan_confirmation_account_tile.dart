import 'package:flutter/material.dart' hide Colors;
import 'dart:math' as math;

import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';

class ConfirmationAccountTile extends StatelessWidget {
  ConfirmationAccountTile(
      {Key? key,
      required this.accountName,
      required this.accountNumber,
      this.padding})
      : super(key: key);

  final String accountName;
  final String accountNumber;
  final EdgeInsets? padding;

  final List<Color> colors = [
    Color(0xff0361F0),
    Color(0xff51E070),
    Color(0xffF08922),
    Color(0xff9B51E0),
    Color(0xffECAB03),
    Color(0xff0B3275),
    Color(0xff1EB12D),
    Color(0xffE05196),
    Color(0xff51ADE0),
  ];

  TextStyle getBoldStyle({
    double fontSize = 14.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 12.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget getAccountCardIcon(String name) {
    final colorIdx = math.Random().nextInt(9);
    final color = colors[colorIdx];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: color.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor: MaterialStateProperty.all(color.withOpacity(0.1)),
              highlightColor: color.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  name.abbreviate(2, true, includeMidDot: false),
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 23.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(11.87, 14.25, 0, 14.17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(
            width: 0.7,
            color: Colors.loanCardShadowColor.withOpacity(0.15),
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
              color: Colors.loanCardShadowColor.withOpacity(0.1),
            ),
          ],
        ),
        child: Row(
          children: [
            Flexible(
              child: getAccountCardIcon(accountName),
              flex: 0,
            ),
            SizedBox(width: 17),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    accountName,
                    style: getBoldStyle(),
                  ),
                  SizedBox(height: 1),
                  Text(
                    accountNumber,
                    style: getNormalStyle(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
