import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';

///@author Paul Okeke
///@Contributor Obinna Igwe
class DashboardMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DashboardMenuItem(
          itemName: "Transfer",
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_dashboard_transfer_2.svg",
            width: 25,
            height: 19,
            color: Colors.primaryColor,
          ),
          routeName: Routes.TRANSFER,
          circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        ),
        _DashboardMenuItem(
          itemName: "Airtime",
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_dashboard_airtime_2.svg",
            width: 19.75,
            height: 31,
            color: Colors.solidOrange,
          ),
          routeName: Routes.AIRTIME,
          circleBackgroundColor: Colors.solidOrange.withOpacity(0.1),
        ),
        _DashboardMenuItem(
          itemName: "Bills",
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_dashboard_bills_2.svg",
            width: 22,
            height: 25,
            color: Colors.solidGreen,
          ),
          routeName: Routes.BILL,
          circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        ),
      ],
    );
  }
}

///_DashboardMenuItem
///
///
///
///
///
///
///
///
class _DashboardMenuItem extends StatelessWidget {

  final String itemName;
  final String routeName;
  final Widget itemIcon;
  final Color circleBackgroundColor;

  _DashboardMenuItem({
    required this.itemName,
    required this.routeName,
    required this.itemIcon,
    required this.circleBackgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.backgroundWhite,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0xff1F0E4FB1).withOpacity(0.12),
            ),
          ]),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.transparent,
        child: InkWell(
          highlightColor: circleBackgroundColor.withOpacity(0.025),
          overlayColor: MaterialStateProperty.all(circleBackgroundColor),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          onTap: () {
            if (routeName.isNotEmpty) {
              Navigator.pushNamed(context, routeName);
            }
          },
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 17),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: circleBackgroundColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: itemIcon),
                ),
                SizedBox(height: 11),
                Text(
                  itemName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    fontSize: 13,
                    color: Colors.textColorBlack.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 11)
              ],
            ),
          ),
        ),
      ),
    );
  }

}