import 'dart:ffi';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class SavingsSuccessView extends StatelessWidget {
  const SavingsSuccessView(
      {Key? key,
      required this.primaryText,
      required this.secondaryText,
      this.content,
      required this.primaryButtonAction,
      required this.primaryButtonText,
      this.secondaryButtonText,
      this.secondaryButtonAction})
      : super(key: key);

  final String primaryText;
  final String secondaryText;
  final Widget? content;
  final String primaryButtonText;
  final VoidCallback primaryButtonAction;
  final String? secondaryButtonText;
  final VoidCallback? secondaryButtonAction;

  TextStyle getBoldStyle(
          {double fontSize = 32.5,
          Color color = Colors.white,
          FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
          {double fontSize = 32.5,
          Color color = Colors.white,
          FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
        child: Scaffold(
          backgroundColor: Color(0xff198724),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    "res/drawables/ic_check_mark_round_alt.svg",
                  ),
                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(height: 10),
                Text(
                  primaryText,
                  style: getBoldStyle(color: Colors.white, fontSize: 32),
                ),
                SizedBox(height: 10),
                Text(secondaryText, style: getNormalStyle(fontSize: 15)),
                if (content != null) SizedBox(height: 20),
                if (content != null) content!,
                Spacer(),
                Styles.statefulButton(
                    buttonStyle: Styles.primaryButtonStyle.copyWith(
                        backgroundColor: MaterialStateProperty.all(
                            Color(0xff115718).withOpacity(0.61)),
                        textStyle: MaterialStateProperty.all(getBoldStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white))),
                    stream: Stream.value(true),
                    onClick: primaryButtonAction,
                    text: primaryButtonText),
                SizedBox(height: 50),
                if (secondaryButtonText != null && secondaryButtonAction != null)
                  SizedBox(height: 10),
                if (secondaryButtonText != null && secondaryButtonAction != null)
                  Styles.statefulButton(
                    buttonStyle: Styles.primaryButtonStyle.copyWith(
                        backgroundColor: MaterialStateProperty.all(Colors.transparent),
                        textStyle: MaterialStateProperty.all(getBoldStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white))),
                    stream: Stream.value(true),
                    onClick: secondaryButtonAction!,
                    text: secondaryButtonText!,
                  ),
                SizedBox(height: secondaryButtonText != null && secondaryButtonAction != null ? 32 : 20),
              ],
            ),
          ),
        ),
    );
  }
}
