import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/dialogs/pnd_instruction_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';

class AccountRestrictionView extends StatelessWidget {

  void _openPndInstruction(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (mContext) {
          return PndInstructionDialog();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 19),
      decoration: BoxDecoration(
          color: Color(0XFFE94444).withOpacity(0.9),
          borderRadius: BorderRadius.circular(4)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 16),
              Container(
                width: 36,
                height: 36,
                padding: EdgeInsets.all(9),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                ),
                child: SvgPicture.asset('res/drawables/ic_pnd_lock.svg', color:Colors.red),
              ),
              SizedBox(width: 14),
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Restricted!',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 1),
                  Text(
                    'Supply the following information to rectify your account.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                ],
              )),
              SizedBox(width: 16),
            ],
          ),
          SizedBox(height: 12,),
          Divider(
            color: Colors.white.withOpacity(0.5),
            height: 1,
          ),
          TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size(10, 0)),
              visualDensity: VisualDensity(vertical: -4)
            ),
            onPressed: () => _openPndInstruction(context),
            child: Text(
              'Learn More',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}