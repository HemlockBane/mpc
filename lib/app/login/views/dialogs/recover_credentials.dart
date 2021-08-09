import 'package:flutter/material.dart' hide Colors;
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
          'Recover Credentials',
          style: TextStyle(
              color: Colors.textColorBlack,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        )),
        SizedBox(height: 30),
        TextButton(
            style: ButtonStyle(
                alignment: Alignment.centerLeft,
                padding: MaterialStateProperty.all(EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16))
            ),
            onPressed: () => {
              Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.USERNAME_RECOVERY)
            },
            child: Text('Recover Username',
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w600))
        ),
        Container(
          height: 0.8,
          color: Color(0XFF055072).withOpacity(0.1),
          width: double.infinity,
          margin: EdgeInsets.only(left: 24, right: 24, top: 6, bottom: 6),
        ),
        TextButton(
            style: ButtonStyle(
                alignment: Alignment.centerLeft,
              padding: MaterialStateProperty.all(EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16))
            ),
            onPressed: () => {
              Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.PASSWORD_RECOVERY)
            },
            child: Text('Recover Password',
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w600
                )
            )
        ),
      ],
    );
  }
}
