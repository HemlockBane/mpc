import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';

class DashboardBottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.colorFaded.withOpacity(0.2), width: 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _menuItem('Airtime', 'res/drawables/ic_menu_airtime.svg', ()=> null)),
          Expanded(child: _menuItem('Transfer', 'res/drawables/ic_menu_transfer.svg', () => Navigator.of(context).pushNamed(Routes.TRANSFER))),
          Expanded(child: _menuItem('Pay Bills', 'res/drawables/ic_menu_bills.svg', ()=> null)),
          Expanded(child: _menuItem('More', 'res/drawables/ic_menu_more.svg', () => Scaffold.of(context).openDrawer())),
        ],
      ),
    );
  }

  Widget _menuItem(String title, String iconRes, VoidCallback onClick) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: onClick,
        // borderRadius: BorderRadius.all(Radius.circular(120)),
        child: Container(
          padding: EdgeInsets.only(top: 24, bottom: 32),
          decoration: BoxDecoration(shape: BoxShape.circle),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(iconRes, width: 24, height: 24,),
              SizedBox(height: 4),
              Text(title, style: TextStyle(color: Color(0XFF626E80), fontSize: 14))
            ],
          ),
        ),
      ),
    );
  }
}