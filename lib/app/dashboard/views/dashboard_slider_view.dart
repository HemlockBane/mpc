import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/dashboard/model/slider_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';

class DashboardSliderView extends StatelessWidget {

  DashboardSliderView({required this.items});

  late final BuildContext context;
  final List<SliderItem> items;
  final PageController _mPageController = PageController(viewportFraction: 1);

  void _onItemClickListener(SliderItem item, int position) {
    if(item.key == "account_update") {
      Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE);
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    if(items.length == 0) return SizedBox();
    return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      child: Stack(
        children: [
          Positioned(
              child: PageView.builder(
                  controller: _mPageController,
                  itemCount: items.length,
                  itemBuilder: (mContext, index) {
                    return _DashboardSliderItem(
                        item: items[index],
                        position: index,
                        totalItems: items.length,
                        itemIcon: Image.asset(items[index].iconPath),
                        onClick: _onItemClickListener,
                    );
                  }
              )
          ),
          Positioned(
              right: 20,
              top: 0,
              bottom: 0,
              child: Visibility(
                  visible: items.length > 1,
                  child: SvgPicture.asset('res/drawables/ic_forward_arrow.svg',
                        height: 18, width: 18, color: Colors.primaryColor
                  ),
              )
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 15,
              child: Visibility(
                visible: items.length > 1,
                child: DotIndicator(
                    controller: _mPageController,
                    itemCount: items.length
                ),
              )
          )
        ],
      ),
    );
  }

}

class _DashboardSliderItem extends StatelessWidget {

  final int position;
  final int totalItems;
  final Widget itemIcon;
  final SliderItem item;
  final OnItemClickListener<SliderItem, int>? onClick;

  _DashboardSliderItem({
    required this.item,
    this.onClick,
    required this.position,
    required this.totalItems,
    required this.itemIcon
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
        highlightColor: Colors.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        onTap: () => onClick?.call(item, position),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: totalItems > 1
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: itemIcon,
            ),
            SizedBox(width: 0/*TODO modify */,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    item.primaryText,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.primaryColor,
                        fontSize: 15
                    )
                ),
                SizedBox(height: 4),
                if(item.secondaryText != null)
                  Text(
                      item.secondaryText ?? "",
                      style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        height: 1.5
                      )
                  ),
                SizedBox(height: totalItems == 1 ? 4 : 0),
              ],
            )
          ],
        ),
      ),
    );
  }



}