import 'package:drawerbehavior/drawerbehavior.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dashboard_util.dart';

class DashboardDrawerView  {

  final DrawerScaffoldController controller;
  final String? accountName;
  final BuildContext context;
  final void Function() refreshCallback;

  DashboardDrawerView(this.context, this.controller,
      {this.accountName, required this.refreshCallback}) : super();

  Future<Null> _closeDrawerWithDelay() {
    return Future.delayed(Duration(milliseconds: 200), (){
      controller.closeDrawer();
    });
  }
  Widget _initialView({Color? backgroundColor, required Widget image}) {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1)
      ),
      child: Center(
        child: image,
      ),
    );
  }


  Widget _drawerListItem(String title, Widget res, VoidCallback onClick) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.white.withOpacity(0.1),
        overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.02)),
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.only(left: 24, right: 0, top: 16, bottom: 16),
          child: Row(
            children: [
              _initialView(
                  image: res
              ),
              SizedBox(width: 20,),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, fontFamily: Styles.defaultFont),)
            ],
          ),
        ),
      ),
    );
  }

  Widget? get _child => Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 24,),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _drawerListItem('Account', SvgPicture.asset('res/drawables/ic_drawer_accounts.svg', color: Colors.white, width: 22, height: 22,), (){
            Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS).then((value) => refreshCallback());
            _closeDrawerWithDelay();
          }),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _drawerListItem('Transfer',  SvgPicture.asset('res/drawables/ic_menu_transfer.svg', color: Colors.white,  width: 20, height: 20,) , (){
            _closeDrawerWithDelay().then((value) => Navigator.of(context).pushNamed(Routes.TRANSFER).then((value) => refreshCallback()));
          }),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _drawerListItem('Airtime & Data', SvgPicture.asset('res/drawables/ic_drawer_airtime_data.svg', color: Colors.white, width: 23, height: 23,), (){
            Navigator.of(context).pushNamed(Routes.AIRTIME).then((value) => refreshCallback());
            _closeDrawerWithDelay();
          }),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _drawerListItem('Bill Payment',  SvgPicture.asset('res/drawables/ic_menu_bills.svg', color: Colors.white, width: 23, height: 23,), (){
            Navigator.of(context).pushNamed(Routes.BILL).then((value) => refreshCallback());
            _closeDrawerWithDelay();
          }),
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, right: 16),
          child: Divider(height: 1, color: Colors.white.withOpacity(0.09),),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: _drawerListItem('Card Management', SvgPicture.asset('res/drawables/ic_drawer_card_management.svg', color: Colors.white,  width: 16, height: 16,), (){
            Navigator.of(context).pushNamed(Routes.CARDS).then((value) => refreshCallback());
            _closeDrawerWithDelay();
          }),
        ),
      ],
    ),
  );

  Widget? get _footerView => Container(
    padding: EdgeInsets.only(left: 24, bottom: 55),
    child: Row(
      children: [
        Styles.imageButton(
            onClick: () {
              Navigator.of(context).pushNamed(Routes.SETTINGS).then((value) => refreshCallback());
              _closeDrawerWithDelay();
            },
            color: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.only(left: 9, right: 9, top: 8, bottom: 8),
            image: SvgPicture.asset('res/drawables/ic_dashboard_settings.svg', width: 22, height: 22,),
            borderRadius: BorderRadius.circular(30)
        ),
        SizedBox(width: 8,),
        Styles.imageButton(
            onClick: () {
              UserInstance().resetSession();
              _closeDrawerWithDelay().then((value) => Navigator.of(context).popAndPushNamed(Routes.LOGIN));
            },
            color: Colors.white.withOpacity(0.1),
            padding: EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
            image: SvgPicture.asset('res/drawables/ic_logout.svg', width: 22, height: 22,),
            borderRadius: BorderRadius.circular(30)
        ),
        SizedBox(width: 8,)
      ],
    ),
  );

  Widget? get _headerView => Container(
    padding: EdgeInsets.only(left: 24, right: 24, top: 40),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg', width: 50, height: 50,),
            Styles.imageButton(
                color: Colors.transparent,
                image: SvgPicture.asset('res/drawables/ic_cancel_dashboard.svg'),
                onClick: () => controller.closeDrawer()
            ),
          ],
        ),
        SizedBox(
          height: 68,
        ),
        Row(
          children: [
            DashboardUtil.getGreetingIcon(DashboardUtil.getTimeOfDay()),
            SizedBox(width: 16,),
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good ${DashboardUtil.getTimeOfDay().replaceAll("Sunset", "Evening")}',
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      accountName ?? "",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                )
            )
          ],
        ),
        SizedBox(height: 32,),
        Row(
          children: [
            Text('NAVIGATION', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, letterSpacing: 0.14, fontWeight: FontWeight.w600),),
            SizedBox(width: 8,),
            Flexible(child: Divider(height:1,color: Colors.white.withOpacity(0.3)))
          ],
        )
      ],
    ),
  );

  SideDrawer getDrawer(){
    return SideDrawer(
      alignment: Alignment.topLeft,
      direction: Direction.left, // Drawer position, left or right
      animation: true,
      color: Colors.colorPrimaryDark,
      percentage: 0.0,
      child: _child,
      footerView: _footerView,
      headerView: _headerView,
    );
  }
}