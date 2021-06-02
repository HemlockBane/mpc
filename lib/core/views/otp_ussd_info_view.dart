import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

import '../styles.dart';
import '../tuple.dart';

class OtpUssdInfoView extends StatelessWidget{

  final String ussdKey;

  OtpUssdInfoView(this.ussdKey);

  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {
    final ussd = getUSSD();

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          SvgPicture.asset('res/drawables/ic_info.svg'),
          SizedBox(width: 14),
          Expanded(child: Text('Didn’t get a code? Dial $ussd to get an OTP',
              style: TextStyle(
                  fontFamily: Styles.defaultFont,
                  color: Colors.colorPrimaryDark,
                  fontWeight: FontWeight.normal,
                  fontSize: 14))
              .colorText({
            ussd: Tuple(
                Colors.primaryColor, () => dialNumber("tel:$ussd"))
          }))
        ],
      ),
    );
  }

}