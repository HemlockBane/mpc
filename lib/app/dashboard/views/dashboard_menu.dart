import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import 'dashboard_menu_item.dart';

///@author Paul Okeke
///@Contributor Obinna Igwe
class DashboardMenu extends StatelessWidget {

  final OnItemClickListener<String, int> onItemClick;

  DashboardMenu(this.onItemClick);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DashboardMenuItem(
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
          DashboardMenuItem(
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
          DashboardMenuItem(
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
      ),
    );
  }
}

