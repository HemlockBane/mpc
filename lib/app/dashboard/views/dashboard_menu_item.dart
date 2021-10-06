import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

///_DashboardMenuItem
///
///
///
///
///
///
///
///
class DashboardMenuItem extends StatelessWidget {

  final String itemName;
  final String routeName;
  final Widget itemIcon;
  final Color circleBackgroundColor;
  final OnItemClickListener<String, int> onItemClick;

  DashboardMenuItem({
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