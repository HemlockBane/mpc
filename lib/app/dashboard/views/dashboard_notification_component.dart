import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/growth/model/data/dashboard_banner_data.dart';
import 'package:moniepoint_flutter/app/growth/model/data/growth_notification.dart';
import 'package:moniepoint_flutter/app/growth/model/data/notification_status_type.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

///@author Paul Okeke
class DashboardNotificationComponent extends StatefulWidget {

  DashboardNotificationComponent({required this.viewModel});

  final BaseViewModel viewModel;

  @override
  State<StatefulWidget> createState() => _DashboardNotificationComponent();

}

///_DashboardNotificationComponent
///
class _DashboardNotificationComponent extends State<DashboardNotificationComponent> {


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.viewModel.growthNotificationStream,
        builder: (ctx, AsyncSnapshot<DashboardBannerData> snap) {

          final dashboardBannerData = snap.data;

          if(!snap.hasData || dashboardBannerData == null) return SizedBox();

          final data = dashboardBannerData.getData();

          if(data.isEmpty == true) return SizedBox();


          return Container(
            margin: EdgeInsets.only(left: 16, right: 16, top: 32),
            padding: EdgeInsets.only(bottom: 10),
            height: 220,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "To Do",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 9.71),
                Expanded(child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (ctx, index) => Padding(padding: EdgeInsets.only(left: 9, right: 9)),
                  itemBuilder: (ctx, index) {
                    final item = data[index];
                    print("Somebody Sec =====>>>>${item.section}");
                    print("Somebody ID =====>>>>${item.id}");
                    print("Somebody key =====>>>>${item.initiativeKey}");
                    return _DashboardComponentItem(
                      item: data[index],
                      position: index,
                      onDismiss: (item, index) {
                        setState(() {
                          dashboardBannerData.update(NotificationStatusType.CLOSE, item);
                        });
                      },
                      onItemClick: (item, index) {
                        dashboardBannerData.update(NotificationStatusType.CLICKED, item);
                      },
                    );
                  },
                )),
                SizedBox(height: 31)
              ],
            ),
          );
        }
    );
  }
}

///_DashboardComponentItem
///
class _DashboardComponentItem extends StatelessWidget {

  _DashboardComponentItem({
    required this.item,
    required this.onItemClick,
    required this.onDismiss,
    required this.position
  });

  final GrowthDashboardBanner item;
  final OnItemClickListener<GrowthDashboardBanner, int> onItemClick;
  final OnItemClickListener<GrowthDashboardBanner, int> onDismiss;
  final int position;

  Color _getColorFromHex(String? hexColor) {
    if(hexColor == null) return Colors.white;
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) return Color(int.parse("0x$hexColor"));
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14.88, top: 11.29, bottom: 15.73, right: 14.63),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
            colors: [
              Colors.white.withOpacity(0.67),
              Colors.white.withOpacity(0),
              _getColorFromHex(item.backgroundColor).withOpacity(0.1)
            ]
        ),
        border: Border.all(
            width: 0.7,
            color: _getColorFromHex(item.backgroundColor).withOpacity(0.1)
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getColorFromHex(item.backgroundColor).withOpacity(0.1),
            offset: Offset(0, 1),
            blurRadius: 2
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(item.image != null) Image.memory(base64Decode(item.image?.trim() ?? ""), width: 80, height: 90,
              errorBuilder: (_i,_j, _k) {
              print(_j);
             return Image.asset("res/drawables/ic_target.png");
          }),
          SizedBox(width: 21),
          Center(
            child: Text(
              item.message ?? "",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack.withOpacity(0.7)
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Styles.imageButton(
                padding: EdgeInsets.all(2),
                color: Colors.transparent,
                onClick: () => onDismiss.call(item, 0),
                image: SvgPicture.asset(
                    "res/drawables/ic_cancel_dashboard.svg",
                    color: Colors.darkBlue.withOpacity(0.2)
                )
            ),
          )
        ],
      ),
    );
  }

}
