
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../colors.dart';
import '../styles.dart';

class TransactionPendingPage extends StatefulWidget {

  final VoidCallback? onClick;
  final String primaryButtonText;
  final String title;
  final String message;

  TransactionPendingPage({
    Key? key,
    this.onClick,
    required this.title,
    required this.message,
    this.primaryButtonText = "Continue",
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionPendingPage();

}

class _TransactionPendingPage extends State<TransactionPendingPage> {

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
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
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
                    color: Colors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.primaryColor.withOpacity(0.31),
                          offset: Offset(0, 8),
                          blurRadius: 22
                      )
                    ]
                ),
              ),
              SizedBox(height: 37),
              Text(
                widget.title,
                style: getBoldStyle(color: Colors.primaryColor, fontSize: 32),
              ),
              SizedBox(height: 28),
              Text(widget.message, style: getNormalStyle(fontSize: 15)),
              SizedBox(height: 27),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: Styles.appButton(
                    elevation: 0.3,
                    buttonStyle: Styles.primaryButtonStyle,
                    onClick: widget.onClick ?? () => Navigator.of(context).pop(),
                    text: widget.primaryButtonText
                ),
              ),
              SizedBox(height: 56)
            ],
          ),
        ),
      ),
    );
  }


}
