import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class DashboardBottomMenu extends StatefulWidget {
  final TabController tabController;

  DashboardBottomMenu (this.tabController);

  @override
  State<StatefulWidget> createState() => _DashboardBottomMenu();

}

class _DashboardBottomMenu extends State<DashboardBottomMenu> {

  static const String HOME = "Home";
  static const String SAVINGS = "Savings";
  static const String LOAN = "Loans";
  static const String MORE = "More";

  int _selectedIndex = 0;

  void onItemClick(String title, int position) {
    if(position >= 0 && position < widget.tabController.length) {
      widget.tabController.animateTo(position);
    }
  }

  bool _isSelected(int position) => position == _selectedIndex;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {
        _selectedIndex = widget.tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0XFFF9FBFD),
            boxShadow: [
              BoxShadow(
                  color: Color(0XFF4A596F).withOpacity(0.12),
                  offset: Offset(0, -9),
                  blurRadius: 21,
                  spreadRadius: 0
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MenuItem(
              title: HOME,
              position: 0,
              icon: SvgPicture.asset(
                "res/drawables/ic_dashboard_home.svg",
                color: _isSelected(0) ? Colors.primaryColor : Color(0XFF9BA6B9),
              ),
              isSelected: _isSelected(0),
              onItemClickListener: onItemClick,
            ),
            _MenuItem(
              title: SAVINGS,
              position: 1,
              icon: SvgPicture.asset(
                "res/drawables/ic_dashboard_piggy.svg",
                color: _isSelected(1) ? Color(0xff1EB12D) : null,
              ),
              titleColor: _isSelected(1) ? Color(0xff1EB12D) : Color(0XFF9BA6B9),
              isSelected: _isSelected(1),
              onItemClickListener: onItemClick,
            ),
            _MenuItem(
              title: LOAN,
              position: 2,
              icon: SvgPicture.asset(
                "res/drawables/ic_dashboard_loan.svg",
                color: _isSelected(2) ? Color(0xffF08922) : null,
              ),
              titleColor: _isSelected(2) ? Color(0xffF08922) : Color(0XFF9BA6B9),
              isSelected: _isSelected(2),
              onItemClickListener: onItemClick,
            ),
            _MenuItem(
                title: MORE,
                position: 3,
                icon: SvgPicture.asset(
                  "res/drawables/ic_dashboard_more.svg",
                  color: _isSelected(3) ? Colors.primaryColor : null,
                ),
                isSelected: _isSelected(3),
                onItemClickListener: onItemClick//onItemClick,
            ),
          ],
        ),
      ),
    );
  }

}

class _MenuItem extends StatelessWidget {

  final String title;
  final Widget icon;
  final bool isSelected;
  final int position;
  final EdgeInsets padding;
  final Color titleColor;

  final OnItemClickListener<String, int>? onItemClickListener;

  _MenuItem({
    required this.title,
    required this.icon,
    this.titleColor = Colors.primaryColor,
    required this.position,
    required this.isSelected,
    required this.onItemClickListener,
    this.padding = const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 12,
    )
  });

  @override
  Widget build(BuildContext context) {
    final padding = this.padding.copyWith(bottom:Platform.isIOS ?  4 : 12);
    return Container(
      child: Material(
        child: InkWell(
          onTap: () => onItemClickListener?.call(title, position),
          overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
          highlightColor: Colors.primaryColor.withOpacity(.001),
          child: Container(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(height: 4,),
                Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? titleColor : Color(0XFF9BA6B9)
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

