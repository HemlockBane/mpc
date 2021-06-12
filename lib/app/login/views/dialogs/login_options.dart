import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class LoginOptionsDialogLayout {


  static Widget getLayout(BuildContext context, {bool isFingerprintAvailable = false, bool hasFingerprintPassword = false})  {
    bool isFingerprintSetup = PreferenceUtil.getFingerPrintEnabled();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 22),
        Center(
            child: Text(
          'How would you like to login?',
          style: TextStyle(
              color: Colors.colorPrimaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 22),
        )),
        SizedBox(height: 30),
        Opacity(
            opacity: (!isFingerprintAvailable || !hasFingerprintPassword || !isFingerprintSetup) ? 0.4 : 1,
            child: TextButton.icon(
              style: ButtonStyle(alignment: Alignment.centerLeft,),
              onPressed: (!isFingerprintAvailable || !hasFingerprintPassword || !isFingerprintSetup)
                  ? null
                  : () => Navigator.of(context).pop("fingerprint"),
              icon: Container(
                margin: EdgeInsets.only(left: 20, right: 22),
                //since there's already a padding on the button
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle
                ),
                child: SvgPicture.asset('res/drawables/ic_finger_print.svg', width: 38, height: 38,),
              ),
              label: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fingerprint',
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)
                  ),
                  SizedBox(height: 3,),
                  Visibility(
                      visible: (!isFingerprintAvailable || !hasFingerprintPassword || !isFingerprintSetup),
                      child: Text(
                        (!isFingerprintAvailable)
                            ? 'Device not supported'
                            : (!hasFingerprintPassword)
                            ? "Fingerprint not setup"
                            : (!isFingerprintSetup)
                            ? "Fingerprint disabled" : "",
                        style: TextStyle(fontSize: 14, color: Colors.textColorMainBlack.withOpacity(0.3)),
                      )
                  )
                ],
              ),
            ),
        ),
        Container(
          height: 0.8,
          color: Color(0XFF055072).withOpacity(0.1),
          width: double.infinity,
          margin: EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 6),
        ),
        TextButton.icon(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () => Navigator.of(context).pop(),
            icon: Container(
              margin: EdgeInsets.only(left: 20, right: 22),
              //since there's already a padding on the button
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle
              ),
              child: SvgPicture.asset('res/drawables/ic_password_lock.svg', width: 27, height: 32,),
            ),
            label: Text('Password',
                style: TextStyle(
                    color: Colors.colorPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
