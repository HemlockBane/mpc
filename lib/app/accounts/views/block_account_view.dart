import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class BlockAccountScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.backgroundWhite,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Block Account',
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
        color: Colors.backgroundWhite,
        height: double.infinity,
        padding: EdgeInsets.only(bottom: 64),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Center(
                    child: Text(
                        'You won’t be able to make any transaction \nvia this account, but you will still be able to \nreceive credits',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),
                    ),
                  ),
                )
            ),
            SizedBox(height: 32),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Styles.appButton(
                    elevation: 0.2,
                    onClick: () => "",
                    text: 'Block'
                ),
              ),
            ),
            SizedBox(height: 12,),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Dismiss', style: TextStyle(color: Colors.red, fontSize: 15),)
            )
          ],
        ),
      ),
    );
  }

}