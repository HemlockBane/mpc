
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

import '../styles.dart';

class SelectionCombo2<T> extends StatefulWidget {
  final List<ComboItem<T>> comboItems;
  final String defaultTitle;
  final BorderRadius? borderRadius;
  final Widget? titleIcon;
  final OnItemClickListener<T?, int>? onItemSelected;

  SelectionCombo2(this.comboItems, {
    this.defaultTitle = "",
    this.borderRadius,
    this.titleIcon,
    this.onItemSelected
  });

  @override
  State<StatefulWidget> createState() => _SelectionCombo2<T>();

  static Widget initialView() {
    return Container(
      width: 34.3,
      height: 34.3,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: SvgPicture.asset('res/drawables/ic_bank.svg', color: Colors.primaryColor,),
      ),
    );
  }

}

class _SelectionCombo2<T> extends State<SelectionCombo2<T>>
    with SingleTickerProviderStateMixin {
  final titleStyle = const TextStyle(fontSize: 14, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold);
  final subtitleStyle = const TextStyle(fontSize: 12, color: Colors.deepGrey, fontFamily: Styles.defaultFont);
  late final _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late final _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
  );

  ComboItem<T>? _selectedCombo;
  bool _isExpanded = true;
  bool _showMore = false;
  int _maxThreshold = 3;
  BorderRadius? _borderRadius;

  @override
  void initState() {
    _borderRadius = widget.borderRadius ??  BorderRadius.circular(10);
    super.initState();
  }

  @override
  void didUpdateWidget(SelectionCombo2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(_isExpanded) _animationController.forward();
    else _animationController.animateBack(_collapseValue);
    _selectedCombo = widget.comboItems.where((element) => element.isSelected).firstOrNull;
  }

  double get _collapseValue {
    int totalNumber = (_showMore) ? widget.comboItems.length : _maxThreshold;
    return 0;
  }
  //0.......1

  Widget _comboHeader() {
    final boldText = _selectedCombo?.subTitle?.substring(0, _selectedCombo?.subTitle?.indexOf("-"));
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.only(
          topRight: _borderRadius!.topLeft,
          topLeft: _borderRadius!.topRight
      ),
      child: InkWell(
        highlightColor: Colors.transparent,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        borderRadius: BorderRadius.only(
            topRight: _borderRadius!.topLeft,
            topLeft: _borderRadius!.topRight
        ),
        onTap: () {
          (_isExpanded) ? _animationController.animateBack(_collapseValue) : _animationController.forward();
          _isExpanded = !_isExpanded;
          setState(() {});
        },
        child: ListTile(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          leading: widget.titleIcon ?? SelectionCombo2.initialView(),
          title: Opacity(
            opacity: (_isExpanded) ? 0.3 : 1,
            child: Text(_selectedCombo?.title ?? widget.defaultTitle, style: titleStyle,),
          ),
          subtitle: (_selectedCombo?.subTitle != null)
              ? Opacity(
                opacity: (_isExpanded) ? 0.3 : 1,
                child: Text(_selectedCombo?.subTitle ?? "", style: subtitleStyle,).colorText(
                    {"$boldText": Tuple(Colors.deepGrey, null)}, underline: false)
              )
              : null,
          trailing: RotationTransition(
              turns: Tween(begin: 0.5, end: 1.0).animate(_animationController),
              child: SvgPicture.asset('res/drawables/ic_drop_down.svg', width: 5, height: 8,)
          ),
        ),
      ),
    );
  }

  void _onItemSelected(ComboItem<T> item, int index) {
    setState(() {
      _selectedCombo?.isSelected = false;
      item.isSelected = true;
      _selectedCombo = item;
    });
    _isExpanded = false;
    _animationController.animateBack(_collapseValue).whenCompleteOrCancel(() {
      _showMore = false;
      widget.onItemSelected?.call(item.value, index);
    });
  }

  List<Widget> _generateItems() {
    final items = <Widget>[];
    final totalItems = widget.comboItems.length;
    final takeLength = (_showMore) ? totalItems : _maxThreshold;

    widget.comboItems.take(takeLength).forEachIndexed((index, element) {
      final comboItem = widget.comboItems[index];

      final boldText = comboItem.subTitle?.substring(0, comboItem.subTitle?.indexOf("-"));

      final listItem = ListTile(
        // dense: true,
        // visualDensity: VisualDensity(vertical: -4),
        onTap: () => _onItemSelected(comboItem, index),
        leading: CustomCheckBox(
            onSelect: (v) =>_onItemSelected(comboItem, index),
            isSelected: comboItem.isSelected
        ),
        title: Text(
          comboItem.title,
          style: titleStyle,
        ),
        subtitle: (comboItem.subTitle != null)
            ? Text(comboItem.subTitle ?? "", style: subtitleStyle,)
                .colorText({"$boldText": Tuple(Colors.deepGrey, null)}, underline: false)
            : null,
      );

      items.add(listItem);

      if (index != takeLength - 1)
        items.add(Divider(color: Colors.grey.withOpacity(0.2), height: 1,));
      
      if((index == takeLength -1) && totalItems > _maxThreshold) {
        items.add(Divider(color: Colors.grey.withOpacity(0.2), height: 1,));
        items.add(TextButton(
            onPressed: () => setState(() => _showMore = !_showMore),
            child: Center(
              child: Text((_showMore) ? "Show Less" : "Show More",
                style: TextStyle(
                    color: Color(0XFF3272E1),
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),
              ),
            )
        ));
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: _borderRadius,
          border: Border.all(color: Color(0XFF0B3175).withOpacity(0.1), width: 0.8, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0B3175).withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 1.2
            )
          ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _comboHeader(),
          (_isExpanded) ? Divider(color: Colors.grey.withOpacity(0.2), height: 1) : SizedBox(),
          SizeTransition(
            axisAlignment: -1.0,
            sizeFactor: _animation,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _generateItems(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
