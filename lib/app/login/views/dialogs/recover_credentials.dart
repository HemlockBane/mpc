import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';

class RecoverCredentialsDialogLayout {
  static Widget getLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 22),
        Center(
            child: Text(
          'What would you like to do?',
          style: TextStyle(
              color: Colors.colorPrimaryDark,
              fontWeight: FontWeight.w600,
              fontSize: 22),
        )),
        SizedBox(height: 30),
        TextButton.icon(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () => {
              Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.USERNAME_RECOVERY)
            },
            icon: Container(
              margin: EdgeInsets.only(left: 20, right: 22),
              //since there's already a padding on the button
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: SvgPicture.asset('res/drawables/ic_circular_user.svg', width: 34, height: 34,),
            ),
            label: Text('Recover Username',
                style: TextStyle(
                    color: Colors.colorPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
        ),
        Container(
          height: 0.8,
          color: Color(0XFF055072).withOpacity(0.1),
          width: double.infinity,
          margin: EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 6),
        ),
        TextButton.icon(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () => {
              Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.PASSWORD_RECOVERY)
            },
            icon: Container(
              margin: EdgeInsets.only(left: 20, right: 22),
              //since there's already a padding on the button
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle
              ),
              child: SvgPicture.asset('res/drawables/ic_password_lock.svg', width: 23, height: 28,),
            ),
            label: Text('Recover Password',
                style: TextStyle(
                    color: Colors.colorPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
