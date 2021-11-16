
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';
import '../styles.dart';

class TransactionErrorPage extends StatefulWidget {

  final VoidCallback? onTryAgain;
  final VoidCallback? onDismiss;

  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final bool displayDismissButton;

  TransactionErrorPage({
    Key? key,
    this.onTryAgain,
    this.onDismiss,
    required this.title,
    required this.message,
    this.primaryButtonText = "Try Again",
    this.secondaryButtonText = "Dismiss",
    this.displayDismissButton = true
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionErrorPage();

}

class _TransactionErrorPage extends State<TransactionErrorPage> {

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }

  TextStyle getBoldStyle(
      {double fontSize = 32.5,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
      {double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Container(
              height: 60,
              width: 60,
              padding: EdgeInsets.all(13),
              child: SvgPicture.asset(
                "res/drawables/ic_info.svg",
                color: Colors.white,
              ),
              decoration:
              BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0XFFD12929).withOpacity(0.31),
                        offset: Offset(0, 8),
                        blurRadius: 22
                    )
                  ]
              ),
            ),
            SizedBox(height: 37),
            Text(
              widget.title,
              style: getBoldStyle(color: Colors.red, fontSize: 32),
            ),
            SizedBox(height: 28),
            Text(widget.message, style: getNormalStyle(fontSize: 15)),
            SizedBox(height: 27),
            Spacer(),
            Styles.statefulButton(
                buttonStyle: Styles.redButtonStyle2,
                stream: Stream.value(true),
                isLoading: false,
                onClick: widget.onTryAgain ?? () => Navigator.of(context).pop(true),
                text: widget.primaryButtonText
            ),
            SizedBox(height: widget.displayDismissButton ? 16 : 0),
            if (widget.displayDismissButton)
              Styles.statefulButton(
                  buttonStyle: Styles.redButtonStyleBordered,
                  stream: Stream.value(true),
                  onClick: widget.onDismiss ?? () => Navigator.of(context).pop(false),
                  text: widget.secondaryButtonText
              ),
            SizedBox(height: 56)
          ],
        ),
      ),
    );
  }


}
