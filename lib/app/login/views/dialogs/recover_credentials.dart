import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class RecoverCredentialsDialogLayout {
  static Widget getLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 22),
        Center(
            child: Text(
          'What would you like to do?',
          style: TextStyle(
              color: Colors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        )),
        SizedBox(height: 29),
        TextButton.icon(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () => {},
            icon: Container(
              margin: EdgeInsets.only(left: 20, right: 22),
              //since there's already a padding on the button
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: SvgPicture.asset('res/drawables/ic_circular_user.svg', width: 30, height: 30,),
            ),
            label: Text('Recover Username',
                style: TextStyle(
                    color: Colors.darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))
        ),
        Container(
          height: 0.8,
          color: Colors.dividerColor.withOpacity(0.1),
          width: double.infinity,
          margin: EdgeInsets.only(left: 38, right: 38, top: 4, bottom: 4),
        ),
        TextButton.icon(
            style: ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () => {},
            icon: Container(
              margin: EdgeInsets.only(left: 20, right: 22),
              //since there's already a padding on the button
              padding: EdgeInsets.all(13),
              decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: SvgPicture.asset('res/drawables/ic_password_lock.svg', width: 30, height: 30,),
            ),
            label: Text('Recover Password',
                style: TextStyle(
                    color: Colors.darkBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold))),
      ],
    );
  }
}
