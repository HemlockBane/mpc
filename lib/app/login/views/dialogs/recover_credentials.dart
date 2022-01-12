import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';

class RecoverCredentialsDialogLayout {

  static Widget _getLeadingIcon(String iconRes) {
    return Container(
      width: 46,
      height: 46,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle
      ),
      child: SvgPicture.asset(
        iconRes,
        color: Colors.primaryColor,
      ),
    );
  }

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
              fontSize: 20),
        )),
        SizedBox(height: 30),
        ListTile(
          leading: _getLeadingIcon('res/drawables/ic_user.svg'),
          contentPadding: EdgeInsets.only(left: 24, right: 24),
          title: Text('Forgot Username',
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          onTap: () => {
            Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.USERNAME_RECOVERY)
          },
          trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.primaryColor,),
        ),
        Container(
          height: 0.8,
          color: Color(0XFF055072).withOpacity(0.1),
          width: double.infinity,
          margin: EdgeInsets.only(left: 86, right: 24, top: 6, bottom: 6),
        ),
        ListTile(
          leading: _getLeadingIcon('res/drawables/ic_savings_lock.svg'),
          contentPadding: EdgeInsets.only(left: 24, right: 24),
          title: Text('Forgot Password',
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              )
          ),
          onTap: () => {
            Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.PASSWORD_RECOVERY)
          },
          trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg', color: Colors.primaryColor,),
        ),
        SizedBox(height: 33,),
        TextButton(
          child: Text(
            "Dismiss",
            style:
            TextStyle(color: Colors.primaryColor, fontSize: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
