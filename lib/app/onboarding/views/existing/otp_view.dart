import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class OTPScreen extends StatelessWidget {


  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {

    final ussd = getUSSD();

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.backgroundWhite,
          iconTheme: IconThemeData(color: Colors.primaryColor)
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
        color: Colors.backgroundWhite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter 6-Digit Code',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.darkBlue,
                fontSize: 21,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 6),
            Text(
                'We’ve just sent a 6-digit code to your registered phone number. Enter the code to proceed.',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.textColorBlack,
                    fontSize: 14)),
            SizedBox(height: 30),
            Styles.appEditText(
                hint: 'Enter 6-Digit Code',
                animateHint: true,
                inputType: TextInputType.number,
                inputFormats: [FilteringTextInputFormatter.digitsOnly],
                startIcon: Icon(CustomFont.bankIcon, color: Colors.colorFaded),
                drawablePadding: 4,
                maxLength: 6),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SvgPicture.asset('res/drawables/ic_info.svg'),
                  SizedBox(width: 14),
                  Text('Didn’t get a code? Dial $ussd to get an OTP',
                          style: TextStyle(
                              fontFamily: Styles.defaultFont,
                              color: Colors.darkBlue,
                              fontWeight: FontWeight.normal,
                              fontSize: 14
                          )
                  ).colorText({ussd: Tuple(Colors.primaryColor, () => dialNumber("tel:$ussd"))})
                ],
              ),
            ),
            Spacer(),
            Styles.appButton(
                onClick: () => Navigator.of(context).pushNamed(''), text: 'Continue'
            ),
            SizedBox(
              height: 66,
            )
          ],
        ),
      ),
    );
  }
}
