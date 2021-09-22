import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/filter_item.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/filter/channel_filter_dialog.dart';
import 'package:moniepoint_flutter/core/views/filter/date_filter_dialog.dart';
import 'package:moniepoint_flutter/core/views/filter/transaction_type_filter_dialog.dart';

typedef DateFilterHandler = void Function(int startDate, int endDate);

class FilterLayout extends StatefulWidget {

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final List<FilterItem> filterableItems;
  final DateFilterHandler? dateFilterCallback;
  final void Function(List<TransactionType> items)? typeFilterCallback;
  final void Function(List<TransactionChannel> items)? channelFilterCallback;
  final VoidCallback? onCancel;
  final VoidCallback? onOpen;
  final bool isPreviouslyOpened;

  FilterLayout(this._scaffoldKey, this.filterableItems, {
    Key? key,
    this.dateFilterCallback,
    this.typeFilterCallback,
    this.channelFilterCallback,
    this.onCancel,
    this.isPreviouslyOpened = false,
    this.onOpen
  }):super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterLayout();

}

class _FilterLayout extends State<FilterLayout> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this,);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(begin: Offset(1.4, 0.0), end: const Offset(0, 0.0),).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  ));

  late final Animation<double> _fadeAnimation = Tween<double>(
    begin: -2.3,
    end: 1.0
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.decelerate,
  ));

  initState() {
    super.initState();
    if(mounted && !widget.isPreviouslyOpened) {
      _controller.forward();
      widget.onOpen?.call();
    }else {
      _controller.value = 1;
    }
  }

  Widget filterPills(int index, FilterItem item, OnItemClickListener<FilterItem, int> itemClickListener) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        onTap: () => itemClickListener.call(item, index),
        child: Container(
          padding: EdgeInsets.only(bottom: 8, top: 8, left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              color: (item.isSelected) ? Colors.primaryColor.withOpacity(0.2) : Colors.primaryColor.withOpacity(0.1)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(item.title,
                  style: TextStyle(
                      color:(item.isSelected) ? Colors.primaryColor : Colors.primaryColor.withOpacity(0.7),
                      fontSize: 13,
                      fontWeight: FontWeight.w600
                  )
              ),
              SizedBox(width: item.isSelected && item.subTitle.length > 0 ? 8 : 0,),
              Visibility(
                visible: item.isSelected && item.subTitle.length > 0,
                child: Text(item.subTitle,
                  style: TextStyle(color: Colors.primaryColor, fontSize: 13,
                    fontWeight: FontWeight.w600)
                  ,),
              ),
              SizedBox(width: item.itemCount > 0 ? 8 : 0),
              Visibility(
                  visible: item.itemCount > 0,
                  child: Container(
                    padding: EdgeInsets.all(4.5),
                    decoration: BoxDecoration(
                        color: Colors.primaryColor,
                        shape: BoxShape.circle
                    ),
                    child: Text(
                      item.itemCount.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  )
              ),
              SizedBox(width: 8,),
              SvgPicture.asset('res/drawables/ic_drop_down.svg', color: Colors.primaryColor,)
            ],
          ),
        ),
      ),
    );
  }

  void _itemClickHandler(FilterItem<dynamic> item, int index) async {
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
        if(result is Tuple<int?, int?>) {
          widget.dateFilterCallback?.call(result.first!, result.second!);
          setState(() {
            final startDate = DateFormat("MMMM d").format(DateTime.fromMillisecondsSinceEpoch(result.first!));
            final toDate = DateFormat("MMMM d").format(DateTime.fromMillisecondsSinceEpoch(result.second!));
            item.isSelected = true;
            item.subTitle = "$startDate - $toDate";
          });
        }
        break;
      }
      case "channel": {
        dynamic result = await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: widget._scaffoldKey.currentContext ?? context,
            builder: (context) {
              return ChannelFilterDialog(selectedChannels: item.values,);
            }
        );
        if(result is List<TransactionChannel>) {
          widget.channelFilterCallback?.call(result);
          setState(() {
            item.values = result;
            item.itemCount = result.length;
            item.isSelected = true;
          });
        }
        break;
      }
      case "type": {
        dynamic result = await showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: widget._scaffoldKey.currentContext ?? context,
            builder: (context) {
              return TransactionTypeFilterDialog(selectedTypes: item.values,);
            }
        );
        if(result is List<TransactionType>) {
          widget.typeFilterCallback?.call(result);
          setState(() {
            item.itemCount = result.length;
            item.isSelected = true;
            item.values = result;
          });
        }
        break;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
            Flexible(
                flex: 0,
                child: GestureDetector(
                  onTap: () async {
                    _controller.reverse(from: 1).whenComplete(() {
                        widget.onCancel?.call();
                    });
                  },
                  child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Cancel', style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w600),
                      ),
                  ),
                )
            ),
            SizedBox(
              width: 16,
            ),
            Flexible(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 40,
                    child: SlideTransition(
                      position: _offsetAnimation,
                      child: ListView.separated(
                          shrinkWrap: false,
                          itemCount: widget.filterableItems.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (ctx, i) => SizedBox(width: 14,),
                          itemBuilder: (context, index) {
                            return filterPills(index, widget.filterableItems[index], _itemClickHandler);
                          }),
                    ),
                  ),
                )
            ),
            SizedBox(
              width: 8,
            ),
          ],
        );
  }
}