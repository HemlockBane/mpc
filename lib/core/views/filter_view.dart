import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/filter/date_filter_dialog.dart';


typedef DateFilterHandler = void Function(int startDate, int endDate);


class FilterLayout extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final List<FilterItem> filterableItems;
  final DateFilterHandler? dateFilterCallback;

  FilterLayout(this._scaffoldKey, this.filterableItems, {this.dateFilterCallback});

  @override
  State<StatefulWidget> createState() => _FilterLayout();

}

class _FilterLayout extends State<FilterLayout> {


  Widget filterPills(int index, FilterItem item, OnItemClickListener<FilterItem, int> itemClickListener) {
    // return Container(
    //   child: Text('Hello', style: TextStyle(color: Colors.red, backgroundColor: Colors.red),),
    // );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        onTap: () => itemClickListener.call(item, index),
        child: Container(
          padding: EdgeInsets.only(bottom: 8, top: 8, left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: (item.isSelected) ? Colors.primaryColor.withOpacity(0.12) : Colors.darkBlue.withOpacity(0.05)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.title,
                  style: TextStyle(
                      color:(item.isSelected) ? Colors.textColorBlack.withOpacity(0.4) : Colors.colorPrimaryDark,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  )
              ),
              SizedBox(width: item.isSelected && item.subTitle.length > 0 ? 8 : 0,),
              Visibility(
                visible: item.isSelected && item.subTitle.length > 0,
                child: Text(item.subTitle, style: TextStyle(color: Colors.darkBlue, fontSize: 14),),
              ),
              SizedBox(width: item.itemCount > 0 ? 8 : 0,),
              Visibility(
                  visible: item.itemCount > 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                      item.itemCount.toString(),
                      style: TextStyle(color: Colors.darkBlue, fontSize: 12),
                    ),
                  )
              ),
              SizedBox(width: 8,),
              SvgPicture.asset('res/drawables/ic_drop_down.svg', color: Colors.darkBlue,)
            ],
          ),
        ),
      ),
    );
  }


  void _itemClickHandler(FilterItem item, int index) async {
    switch(item.title.toLowerCase()) {
      case "date": {
        dynamic result = await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: widget._scaffoldKey.currentContext ?? context,
            builder: (context) {
              return DateFilterDialog();
            }
        );

        if(result is Tuple<int, int>) {
          widget.dateFilterCallback?.call(result.first, result.second);
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16,
            ),
            Flexible(flex: 0, child: Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),)),
            SizedBox(
              width: 16,
            ),
            Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 40,
                    child: ListView.separated(
                        shrinkWrap: false,
                        itemCount: widget.filterableItems.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder: (ctx, i) => SizedBox(width: 8,),
                        itemBuilder: (context, index) {
                          return filterPills(index, widget.filterableItems[index], _itemClickHandler);
                        }),
                  ),
                )),
            SizedBox(
              width: 8,
            ),
          ],
        );
  }
}