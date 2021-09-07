import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

/// @author Paul Okeke
/// @contributor Obinna Igwe
class DashboardDrawer extends StatelessWidget {

  final double width;
  final OnItemClickListener<String, int> onItemClick;

  DashboardDrawer(this.width, this.onItemClick);

  Container _groupTitle(BuildContext context, String title) {
    return Container(
      margin: EdgeInsets.only(left: 39, right: 20),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.15),
                letterSpacing: 1.3),
          ),
          SizedBox(width: 10),
          Expanded(
              child: Divider(height: 1, color: Colors.white.withOpacity(0.3))),
        ],
      ),
    );
  }

  Widget _icon(
      {required String svgPath,
      Color? color,
      double? width,
      double? height,
      VoidCallback? onClick}) {
    return InkWell(
      highlightColor: Colors.white.withOpacity(0.1),
      overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
      onTap: onClick,
      child: SvgPicture.asset(
        svgPath,
        width: width ?? 21,
        height: height ?? 21,
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.width,
      child: Drawer(
        child: Container(
          color: Colors.colorPrimaryDark,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.solidDarkBlue.withOpacity(0.5),
                          Colors.solidDarkBlue
                        ],
                        stops: [
                          0.8,
                          1.0
                        ]),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 58),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _icon(
                            svgPath: "res/drawables/ic_moniepoint_cube_2.svg",
                            width: 40,
                            height: 40),
                        Row(
                          children: [
                            _icon(
                                svgPath:
                                    "res/drawables/ic_dashboard_settings.svg",
                                onClick: () => Navigator.pushNamed(
                                    context, Routes.SETTINGS)),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        SizedBox(height: 24),
                        _groupTitle(context, "TRANSACTIONS"),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_transfer_2.svg",
                            width: 21,
                            height: 17,
                          ),
                          title: "Transfer Money",
                          routeName: Routes.TRANSFER,
                          iconSpacing: 9,
                          onTap: onItemClick,
                        ),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_airtime_2.svg",
                            height: 26,
                          ),
                          title: "Airtime & Data",
                          routeName: Routes.AIRTIME,
                          iconSpacing: 16,
                          onTap: onItemClick,
                        ),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_bills_2.svg",
                          ),
                          title: "Bill Payments",
                          routeName: Routes.BILL,
                          iconSpacing: 15,
                          onTap: onItemClick,
                        ),
                        SizedBox(height: 21),
                        _groupTitle(context, "ACCOUNTS & CARDS"),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_manage_account.svg",
                            height: 26,
                          ),
                          title: "Manage Account",
                          routeName: Routes.ACCOUNT_TRANSACTIONS,
                          iconSpacing: 6.8,
                          onTap: onItemClick,
                        ),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_manage_cards.svg",
                            height: 18,
                          ),
                          title: "Manage Cards",
                          routeName: Routes.CARDS,
                          iconSpacing: 11.4,
                          onTap: onItemClick,
                        ),
                        SizedBox(height: 21),
                        _groupTitle(context, "SAVINGS & LOANS"),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_savings.svg",
                            height: 26,
                          ),
                          title: "Savings",
                          onTap: onItemClick,
                          routeName: "COMING_SOON",
                          iconSpacing: 7.5,
                        ),
                        _DrawerListItem(
                          itemIcon: SvgPicture.asset(
                            "res/drawables/ic_dashboard_manage_cards.svg",
                            height: 18,
                          ),
                          routeName: "COMING_SOON",
                          title: "Get Loan",
                          onTap: onItemClick,
                          iconSpacing: 11,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 120)
                ],
              ),
              Positioned(
                bottom: 64,
                left: 0,
                right: 100,
                child: _DrawerListItem(
                  itemIcon: SvgPicture.asset("res/drawables/ic_logout.svg"),
                  title: "Log Out",
                  routeName: "LOGOUT",
                  onTap: onItemClick,
                  iconSpacing: 11,
                ),
              ),
              Positioned(
                bottom: 64,
                right: 36,
                child: Material(
                  shape: CircleBorder(),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: _icon(
                        svgPath: "res/drawables/ic_cancel_dashboard.svg",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// _DrawListItem
///
///
///
///
///
///
///
///
class _DrawerListItem extends StatelessWidget {
  final Widget itemIcon;
  final String title;
  final OnItemClickListener<String, int>? onTap;
  final String? routeName;
  final double? iconSpacing;

  _DrawerListItem(
      {required this.itemIcon,
      required this.title,
      this.routeName,
      this.onTap,
      this.iconSpacing});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
        onTap: () => onTap?.call(routeName ?? "", 0),
        child: Container(
          padding: EdgeInsets.only(left: 40, right: 0, top: 20, bottom: 20),
          child: Row(
            children: [
              itemIcon,
              SizedBox(width: iconSpacing ?? 10),
              Text(
                title,
                style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
