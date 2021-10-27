import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_bottom_menu.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/moniepoint_scaffold.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

import 'dashboard_top_menu.dart';

class MoreView extends StatefulWidget {
  MoreView({Key? key}) : super(key: key);

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {

  void onItemClick(String routeName, int position) {
    final _viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    switch (routeName) {
      case Routes.ACCOUNT_TRANSACTIONS:{
          if (_viewModel.userAccounts.length == 0) return;
          // Get first user account by default
          final userAccount = _viewModel.userAccounts.first;
          final routeArgs = {"userAccountId": userAccount.id};
          Navigator.of(context).pushNamed(routeName, arguments: routeArgs);
          break;
      }
      case "LOGOUT":{
          UserInstance().resetSession();
          MoniepointAppMessenger.of(navigatorKey.currentContext!).clearAllInAppNotification();
          Navigator.of(context).popAndPushNamed(Routes.LOGIN);
          break;
      }
      default:{
          Navigator.of(context).pushNamed(routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      color: Color(0XFFEBF2FA),
      child: SingleChildScrollView(
        padding: MediaQuery.maybeOf(context)?.padding.copyWith(left: 0, right: 0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardMenuItem(
                  itemName: "Cards",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_more_cards.svg",
                    width: 25,
                    height: 19,
                    color: Colors.primaryColor,
                  ),
                  routeName: Routes.CARDS,
                  circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                ),
                DashboardMenuItem(
                  itemName: "Account",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_more_account.svg",
                    width: 19.75,
                    height: 31,
                    color: Colors.primaryColor,
                  ),
                  routeName: Routes.ACCOUNT_TRANSACTIONS,
                  circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                ),
                DashboardMenuItem(
                  itemName: "Beneficiaries",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_more_beneficiaries.svg",
                    width: 22,
                    height: 25,
                    color: Colors.primaryColor,
                  ),
                  routeName: Routes.MANAGED_BENEFICIARIES,
                  circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                ),
              ],
            ),
            SizedBox(height: 22,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DashboardMenuItem(
                  itemName: "Devices",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_dashboard_airtime_2.svg",
                    width: 19.75,
                    height: 31,
                    color: Colors.primaryColor,
                  ),
                  routeName: Routes.REGISTERED_DEVICES,
                  circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                ),
                DashboardMenuItem(
                  itemName: "Settings",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_more_settings.svg",
                    width: 19.75,
                    height: 31,
                    color: Colors.primaryColor,
                  ),
                  routeName: Routes.SETTINGS,
                  circleBackgroundColor: Colors.primaryColor.withOpacity(0.1),
                ),
                DashboardMenuItem(
                  itemName: "Logout",
                  onItemClick: onItemClick,
                  itemIcon: SvgPicture.asset(
                    "res/drawables/ic_logout.svg",
                    width: 19.75,
                    height: 31,
                    color: Colors.red,
                  ),
                  routeName: "LOGOUT",
                  circleBackgroundColor: Colors.red.withOpacity(0.1),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
