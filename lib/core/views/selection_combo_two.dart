
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';


import '../styles.dart';


class SelectionCombo2<T> extends StatefulWidget {
  final List<ComboItem<T>> comboItems;
  final String defaultTitle;
  final BorderRadius? borderRadius;
  final Widget? titleIcon;
  final OnItemClickListener<T?, int>? onItemSelected;
  final Color? primaryColor;
  final Widget Function() ? subtitleWidget;
  final Widget? trailingWidget;
  final Color? checkBoxBorderColor;
  final Size? checkBoxSize;
  final EdgeInsets? checkBoxPadding;
  final bool isShowTrailingWhenExpanded;
  final TextStyle? titleStyle;
  final ListStyle listStyle;
  final bool shouldPreselectFirstAccount;


  SelectionCombo2(this.comboItems, {
    this.defaultTitle = "",
    this.borderRadius,
    this.titleIcon,
    this.onItemSelected,
    this.primaryColor,
    this.subtitleWidget,
    this.trailingWidget,
    this.checkBoxBorderColor,
    this.checkBoxSize,
    this.checkBoxPadding,
    this.isShowTrailingWhenExpanded = true,
    this.titleStyle,
    this.listStyle = ListStyle.normal,
    this.shouldPreselectFirstAccount = false
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
  final subtitleStyle = const TextStyle(fontSize: 12, color: Colors.deepGrey, fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]);
  late final _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  late final _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
  );

  ComboItem<T>? _selectedCombo;
  late bool _isExpanded;
  bool _showMore = false;
  int _maxThreshold = 3;
  BorderRadius? _borderRadius;

  @override
  void initState() {
    _borderRadius = widget.borderRadius ??  BorderRadius.circular(10);
    _isExpanded = widget.shouldPreselectFirstAccount ? false: true;
    super.initState();
  }

  @override
  void didUpdateWidget(SelectionCombo2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.shouldPreselectFirstAccount){
      selectFirstAccount();
    }else{
      if(_isExpanded) _animationController.forward();
      else _animationController.animateBack(_collapseValue);
      selectFirstAccount();
    }
    }



  void selectFirstAccount(){
    _selectedCombo = widget.comboItems.where((element) => element.isSelected).firstOrNull;
  }

  double get _collapseValue {
    int totalNumber = (_showMore) ? widget.comboItems.length : _maxThreshold;
    return 0;
  }
  //0.......1

  bool isDefaultStyle() =>  widget.listStyle == ListStyle.normal;

  Widget? getTrailingWidget(){
    final isShow = widget.isShowTrailingWhenExpanded;
    final icon =  widget.trailingWidget ?? RotationTransition(
      turns: Tween(begin: 0.5, end: 1.0).animate(_animationController),
      child: SvgPicture.asset('res/drawables/ic_drop_down.svg', width: 5, height: 8,)
    );

    return (!isShow && _isExpanded)
      ? SizedBox()
      : icon;
  }

  Widget getAlternateSubtitle({required String text1, required String? tex2}){
    return Row(
      children: [
        Text(
          text1,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.textColorBlack
              .withOpacity(0.5),
            fontSize: 13),
        ),
        SizedBox(
          width: 8,
        ),
        Text("$tex2",
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.textColorBlack
              .withOpacity(0.5),
            fontSize: 13,
            fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget? getAlternateIcon(String? name){
    final color = widget.primaryColor ?? Colors.primaryColor;
    if (name == null) return null;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: color.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor:
              MaterialStateProperty.all(color.withOpacity(0.1)),
              highlightColor: color.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  name.abbreviate(2, true, includeMidDot: false),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _comboHeader() {
    final boldText = _selectedCombo?.subTitle?.substring(0, _selectedCombo?.subTitle?.indexOf("-"));
    final titleStyle = widget.titleStyle ?? const TextStyle(fontSize: 14, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold, fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]);

   final userAccount = (_selectedCombo?.value as UserAccount?);
   final accountName = userAccount?.customerAccount?.accountName;
   final formattedBalance = userAccount?.accountBalance?.availableBalance?.formatCurrency ?? "--";

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
          leading: isDefaultStyle() ? widget.titleIcon : getAlternateIcon(accountName),
          title: Opacity(
            opacity: (_isExpanded) ? 0.3 : 1,
            child: Text(_selectedCombo?.title ?? widget.defaultTitle, style: titleStyle,),
          ),
          subtitle: (_selectedCombo?.subTitle != null)
              ? Opacity(
                opacity: (_isExpanded) ? 0.3 : 1,
                child: !isDefaultStyle()
                  ? getAlternateSubtitle(text1: boldText ?? "", tex2: formattedBalance)
                  : Text(_selectedCombo?.subTitle ?? "", style: subtitleStyle).colorText(
                    {"$boldText": Tuple(Colors.deepGrey, null)}, underline: false)
              )
              : null,
          trailing: getTrailingWidget()
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
    final titleStyle = widget.titleStyle ?? const TextStyle(fontSize: 14, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold, fontFamily: Styles.defaultFont, fontFamilyFallback: ["Roboto"]);



    final items = <Widget>[];
    final totalItems = widget.comboItems.length;
    final takeLength = (_showMore) ? totalItems : _maxThreshold;

    widget.comboItems.take(takeLength).forEachIndexed((index, element) {
      final comboItem = widget.comboItems[index];

      final boldText = comboItem.subTitle?.substring(0, comboItem.subTitle?.indexOf("-"));
      final formattedBalance = (comboItem.value as UserAccount?)?.accountBalance?.availableBalance?.formatCurrency ?? "--";


      final listItem = ListTile(
        // dense: true,
        // visualDensity: VisualDensity(vertical: -4),
        onTap: () => _onItemSelected(comboItem, index),
        leading: CustomCheckBox(
            height: widget.checkBoxSize?.height, width: widget.checkBoxSize?.width,
            onSelect: (v) =>_onItemSelected(comboItem, index),
            isSelected: comboItem.isSelected,
          fillColor: widget.primaryColor,
          borderColor: widget.checkBoxBorderColor,
          padding: widget.checkBoxPadding,
        ),
        title: Text(
          comboItem.title,
          style: titleStyle,
        ),
        subtitle: (comboItem.subTitle != null)
            ? isDefaultStyle()
              ? Text(comboItem.subTitle ?? "", style: subtitleStyle,).colorText({"$boldText": Tuple(Colors.deepGrey, null)}, underline: false)
              : getAlternateSubtitle(text1: boldText ?? "", tex2: formattedBalance)
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
