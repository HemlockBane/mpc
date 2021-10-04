import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';

class DashboardBottomMenu extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;// = GlobalKey<ScaffoldState>();

  DashboardBottomMenu (this.scaffoldKey);

  @override
  State<StatefulWidget> createState() => _DashboardBottomMenu();

}

class _DashboardBottomMenu extends State<DashboardBottomMenu> {

  String _selectedTitle = HOME;

  static const String HOME = "Home";
  static const String SAVINGS = "Savings";
  static const String LOAN = "Loan";
  static const String MORE = "More";

  void onItemClick(String title, int? position) {
    setState(() {
      _selectedTitle = title;
    });
    if(title == SAVINGS || title == LOAN) {
      showComingSoon(context);
    }
    if(title == MORE) {
      widget.scaffoldKey.currentState?.openDrawer();
    }
  }

  bool _isSelected(String title) => title == _selectedTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0XFFF9FBFD),
        boxShadow: [
          BoxShadow(
            color: Color(0XFF0E4FB1).withOpacity(0.12),
            offset: Offset(0, -9),
            blurRadius: 21,
            spreadRadius: 0
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _MenuItem(
            title: HOME,
            icon: SvgPicture.asset(
                "res/drawables/ic_dashboard_home.svg",
              color: _isSelected(HOME) ? Colors.primaryColor : Color(0XFF9BA6B9),
            ),
            padding: EdgeInsets.only(left: 42, right: 28, top: 17, bottom: 26),
            isSelected: _isSelected(HOME),
            onItemClickListener: onItemClick,
          ),
          _MenuItem(
            title: SAVINGS,
            icon: SvgPicture.asset(
              "res/drawables/ic_dashboard_piggy.svg",
              color: _isSelected(SAVINGS) ? Colors.primaryColor : null,
            ),
            isSelected: _isSelected(SAVINGS),
            onItemClickListener: onItemClick,
          ),
          _MenuItem(
            title: LOAN,
            icon: SvgPicture.asset(
              "res/drawables/ic_dashboard_loan.svg",
              color: _isSelected(LOAN) ? Colors.primaryColor : null,
            ),
            isSelected: _isSelected(LOAN),
            onItemClickListener: onItemClick,
          ),
          _MenuItem(
              title: MORE,
              icon: SvgPicture.asset(
                "res/drawables/ic_dashboard_more.svg",
                color: _isSelected(MORE) ? Colors.primaryColor : null,
              ),
              padding: EdgeInsets.only(left: 28, right: 42, top: 17, bottom: 26),
              isSelected: _isSelected(MORE),
              onItemClickListener: onItemClick//onItemClick,
          ),
        ],
      ),
    );
  }

}

class _MenuItem extends StatelessWidget {

  final String title;
  final Widget icon;
  final bool isSelected;
  final EdgeInsets padding;
  final OnItemClickListener<String, int>? onItemClickListener;

  _MenuItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onItemClickListener,
    this.padding = const EdgeInsets.only(left: 28, right: 28, top: 17, bottom: 26)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        child: InkWell(
          onTap: () => onItemClickListener?.call(title, -1),
          overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
          highlightColor: Colors.primaryColor.withOpacity(.001),
          child: Container(
            padding: padding,
            child: Column(
              children: [
                icon,
                SizedBox(height: 4,),
                Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.primaryColor : Color(0XFF9BA6B9)
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



class AppBottomNavigationBarItem {
  AppBottomNavigationBarItem({required this.svgPath, required this.title});

  String svgPath;
  String title;
}

class AppBottomNavigationBar extends StatefulWidget {
  final OnItemClickListener<String, int>? onItemClickListener;
  final List<AppBottomNavigationBarItem> items;
  final Color color;
  final Color selectedColor;
  final double height;

  const AppBottomNavigationBar(
    {required this.onItemClickListener,
      required this.items,
      this.color = Colors.grey,
      this.selectedColor = Colors.black,
      this.height = 60});

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items(),
      ),
    );
  }

  List<Widget> _items() {
    return List.generate(widget.items.length, (int index) {
      return _buildTabItem(
        navigationBarItem: widget.items[index],
        index: index,
        onPressed: _updateSelectedIndex);
    });
  }
  
  Color getColor(String title){
    if (title == "Savings") return Color(0xff1EB12D);
    if (title == "Loan") return Color(0xffF08922);
    return Colors.primaryColor;
  }

  Widget _buildTabItem(
    {required AppBottomNavigationBarItem navigationBarItem,
      required int index,
      required OnItemClickListener<String, int>? onPressed}) {
    Color color = _selectedIndex == index ? getColor(navigationBarItem.title) : Color(0XFF9BA6B9);
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed?.call(navigationBarItem.title, index),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Icon(
                //   navigationBarItem.iconData,
                //   color: color,
                //   size: widget.iconSize,
                // ),
                SvgPicture.asset(
                  navigationBarItem.svgPath,
                  color: color,
                ),
                Text(
                  navigationBarItem.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color),
                )
              ],
            ),
          ),
        ),
      ));
  }

  _updateSelectedIndex(String title, int index) {
    widget.onItemClickListener?.call(title, index);
    setState(() {
      _selectedIndex = index;
    });
  }
}
