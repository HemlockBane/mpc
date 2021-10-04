import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

///@author Paul Okeke
///@Contributor Obinna Igwe
class DashboardMenu extends StatelessWidget {

  final OnItemClickListener<String, int> onItemClick;

  DashboardMenu(this.onItemClick);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DashboardMenuItem(
          itemName: "Transfer",
          onItemClick: onItemClick,
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
          onItemClick: onItemClick,
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_dashboard_airtime_2.svg",
            width: 19.75,
            height: 31,
            color: Colors.primaryColor,
          ),
          routeName: Routes.AIRTIME,
          circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        ),
        _DashboardMenuItem(
          itemName: "Bills",
          onItemClick: onItemClick,
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_dashboard_bills_2.svg",
            width: 22,
            height: 25,
            color: Colors.primaryColor,
          ),
          routeName: Routes.BILL,
          circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
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
  final OnItemClickListener<String, int> onItemClick;

  _DashboardMenuItem({
    required this.itemName,
    required this.routeName,
    required this.onItemClick,
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
          onTap: () => onItemClick.call(routeName, 0),
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