import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class UnblockDebitCardScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.primaryColor,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Colors.transparent,
          elevation: 0
      ),
      body: Container(
        color: Colors.primaryColor,
        height: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 64),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'Unblock your Debit Card',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 24),
            Text(
              'Visit your nearest Moniepoint Branch to\nunblock your card.',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 100,),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Styles.appButton(
                  elevation: 0.2,
                  onClick: () => Navigator.of(context).pushNamed(Routes.BRANCHES),
                  text: 'Find branches closest to you',
                  buttonStyle: Styles.whiteButtonStyle,
                  textColor: Colors.primaryColor
              ),
            )
          ],
        ),
      ),
    );
  }

}