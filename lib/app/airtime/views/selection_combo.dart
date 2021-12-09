import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/views/custom_expansion_tile.dart';

class SelectionCombo<T> extends StatefulWidget {

  final List<ComboItem<T>> comboItems;
  final int maxDisplayValue;
  final bool useFirstItemAsTitle;
  final Color dividerColor;
  final OnItemClickListener<T?, int> onItemSelected;
  final CheckBoxPosition checkBoxPosition;
  final bool shouldUseAlternateDecoration;
  final Color primaryColor;
  final Color? backgroundColor;
  final double? horizontalPadding;
  final bool isColonSeparated;

  SelectionCombo(this.comboItems, this.onItemSelected, {
    this.maxDisplayValue = 3,
    this.useFirstItemAsTitle = true,
    this.dividerColor = Colors.comboDividerColor,
    this.primaryColor = Colors.primaryColor,
    this.backgroundColor,
    this.shouldUseAlternateDecoration = false,
    this.checkBoxPosition = CheckBoxPosition.trailing,
    this.horizontalPadding,
    this.isColonSeparated = false,
    Key? key
  }):super(key: key);

  @override
  State<StatefulWidget> createState() => _SelectionCombo<T>();

}

class _SelectionCombo<T> extends State<SelectionCombo<T>> {

  ComboItem<T>? selectedCombo;
  ComboItem<T>? topItem;
  bool isExpanded = true;
  bool showMore = false;
  List<ComboItem<T>> copiedList = [];

  int selectedIndex = -1;

  static const PADDING_LEFT = 16.0;
  static const PADDING_RIGHT = 16.0;


  final defaultDecoration =  BoxDecoration(
    border: Border.all(color: Color(0XFF190B3175), width: 0.5),
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Color(0XFF190B3175),
        offset: Offset(0, 0.5),
        blurRadius: 1
      )
    ]
  );

  BoxDecoration getAlternateDecoration() =>  BoxDecoration(
    color: widget.backgroundColor ?? widget.primaryColor.withOpacity(0.15),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );

  TextStyle getAlternateTextStyle() => TextStyle(color: Colors.textColorBlack, fontWeight: FontWeight.w500, fontSize: 15, fontFamily: Styles.defaultFont);


  Widget listItem(ComboItem<T> comboItem, int index) {
    return GestureDetector(
      onTap: () => _itemSelected(comboItem, index),
      child: Container(
        padding: EdgeInsets.only(left: PADDING_LEFT, right: PADDING_RIGHT, top: 9, bottom: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
                visible: comboItem.icon != null,
                child: (comboItem.icon != null) ? comboItem.icon! : SizedBox()
            ),
            Visibility(
                visible: comboItem.icon != null,
                child: (comboItem.icon != null) ? SizedBox(width: 14,) : SizedBox()
            ),
            Expanded(
                child: Text(
                  comboItem.title,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold, fontSize: 14),
                )
            ),
            SizedBox(width: 8,),
            Expanded(
                flex: 0,
                child: CustomCheckBox(
                  isSelected: comboItem.isSelected,
                  fillColor: widget.primaryColor,
                  borderColor: widget.shouldUseAlternateDecoration ? Color(0xffA6B6CE).withOpacity(0.95) : widget.primaryColor,
                  onSelect: (value) {
                    _itemSelected(comboItem, index);
                  },
                )
            )
          ],
        ),
      ),
    );
  }

  Widget leadingCheckBoxListItem(ComboItem<T> comboItem, int index) {
    var firstText = "";
    var secondText = "";
    final hasColon = widget.isColonSeparated && comboItem.title.contains(";");

    if (hasColon){
      final colonIdx = comboItem.title.indexOf(";");
      firstText = comboItem.title.substring(0, colonIdx);
      secondText = comboItem.title.substring(colonIdx + 1);
    }

    return GestureDetector(
      onTap: () => _itemSelected(comboItem, index),
      child: Container(
        padding: EdgeInsets.only(left: widget.horizontalPadding ?? PADDING_LEFT, right: PADDING_RIGHT, top: 9, bottom: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomCheckBox(
              height: 40, width: 40,
              fillColor: widget.primaryColor,
              borderColor: widget.shouldUseAlternateDecoration ? Color(0xffA6B6CE).withOpacity(0.95) : widget.primaryColor,
              isSelected: comboItem.isSelected,
              onSelect: (value) {
                _itemSelected(comboItem, index);
              },
            ),
            SizedBox(width: 9),
            Expanded(
              child: hasColon
                ? Row(
                    children: [
                      Text(firstText, style: getAlternateTextStyle(),),
                      SizedBox(width: 8,),
                      Text(secondText, style: getAlternateTextStyle().copyWith(fontWeight: FontWeight.w700),)],)
                : Text(
                    comboItem.title,
                    textAlign: TextAlign.start,
                    style: getAlternateTextStyle(),
              )
            ),
          ],
        ),
      ),
    );
  }


  Widget getDivider() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: Divider(color: widget.dividerColor.withOpacity(0.3), height: 0.7,),
    );
  }


  Widget titleRoundedCheckBox({Size? size}) => CustomCheckBox(
    height: size?.height, width: size?.width,
    padding: EdgeInsets.all(6),
    isSelected: selectedCombo?.isSelected ?? false,
    fillColor: widget.primaryColor,
    borderColor: widget.shouldUseAlternateDecoration ? Color(0xffA6B6CE).withOpacity(0.95) : widget.primaryColor,
    onSelect: (a) {
      if(copiedList.isEmpty) return;
      setState(() {
        final firstItem = copiedList.first;
        firstItem.isSelected = !firstItem.isSelected;
        selectedCombo = firstItem.isSelected ? firstItem : null;
        if(selectedCombo == null) {
          isExpanded = true;
        } else {
          selectedIndex = 0;
          isExpanded = false;
        }
        widget.onItemSelected.call(selectedCombo?.value, 0);
      });
    },
  );

  Widget getTitle() {
    if(widget.useFirstItemAsTitle && copiedList.length > 0) {
      ComboItem<T> firstCombo = copiedList.first;
      if (widget.checkBoxPosition == CheckBoxPosition.leading){
        var firstText = "";
        var secondText = "";
        final hasColon = widget.isColonSeparated && firstCombo.title.contains(";");

        if (hasColon){
          final colonIdx = firstCombo.title.indexOf(";");
           firstText = firstCombo.title.substring(0, colonIdx);
           secondText = firstCombo.title.substring(colonIdx + 1);
        }



        return Container(
          padding: EdgeInsets.only(left: widget.horizontalPadding ?? PADDING_LEFT, right: PADDING_RIGHT, top: 9, bottom: 9),
          child: Row(
            children: [
              titleRoundedCheckBox(size: Size(40, 40)),
              SizedBox(width: 9),
              hasColon
                ? Row(
                    children: [
                      Text(firstText, style: getAlternateTextStyle(),),
                      SizedBox(width: 8,),
                      Text(secondText, style: getAlternateTextStyle().copyWith(fontWeight: FontWeight.w700),)
                    ],)
                : Text(firstCombo.title, style: getAlternateTextStyle())
            ],
          ),
        );

      }

      return Padding(
        padding: EdgeInsets.only(left: PADDING_LEFT, right: PADDING_RIGHT, top: 9, bottom: 9),
        child: Row(
          children: [
            Visibility(
              visible: firstCombo.icon != null,
              child: (firstCombo.icon != null) ? firstCombo.icon! : SizedBox()
            ),
            Visibility(
              visible: firstCombo.icon != null,
              child: (firstCombo.icon != null) ? SizedBox(width: 14,) : SizedBox()
            ),
            Text(firstCombo.title, style: TextStyle(color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold, fontSize: 14, fontFamily: Styles.defaultFont))
          ],
        ),
      );
    }
    return Text('title');
  }

  List<Widget> generateItems() {
    List<Widget> widgets = [];
    Iterable<ComboItem<T>> maxDisplayableItems = copiedList
      .skip(widget.useFirstItemAsTitle ? 1 : 0)
      .take(showMore ? copiedList.length : widget.maxDisplayValue)
      .sorted((a, b) => a.title.compareTo(b.title));

    maxDisplayableItems.forEachIndexed((index, element) {
      if(widget.useFirstItemAsTitle && index == 0) {
        widgets.add(getDivider());
      }

      if(widget.checkBoxPosition == CheckBoxPosition.leading){
        widgets.add(leadingCheckBoxListItem(element, index));
      }

      if (widget.checkBoxPosition == CheckBoxPosition.trailing){
        widgets.add(listItem(element, index));
      }

      if(index < maxDisplayableItems.length - 1) {
        widgets.add(getDivider());
      }
    });
    return widgets;
  }


  void _setDefaultSelected() {
    final defaultItem = this.copiedList.where((element) => element.isSelected).firstOrNull;
    if (defaultItem != null) {
      defaultItem.isSelected = false;
      _itemSelected(defaultItem, 0);
    }
  }

  initState() {
    this.copiedList = List.from(widget.comboItems);
    super.initState();
    _setDefaultSelected();
  }

  @override
  void didUpdateWidget(covariant SelectionCombo<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(copiedList.isEmpty && widget.comboItems.isNotEmpty) {
      copiedList = List.from(widget.comboItems);
      setState(() {});
    }
  }

  void _itemSelected(ComboItem<T> comboItem, int index) {
    selectedCombo?.isSelected = false;
    selectedCombo = comboItem;
    comboItem.isSelected = !comboItem.isSelected;
    isExpanded = false;
    _expandCallback(false);
  }



  void toggleItem() {

  }

  @override
  Widget build(BuildContext context) {
    final item = isExpanded
      ? SizedBox()
      : IgnorePointer(
          child: TextButton(
              onPressed: (){}, child: Text("Change"),
              style: TextButton.styleFrom(
                primary: widget.primaryColor,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 14, color: widget.primaryColor)),
          ),
      );
    
    final isTrailingCheckBox = widget.checkBoxPosition == CheckBoxPosition.trailing;

    return Container(
      decoration: widget.shouldUseAlternateDecoration ? getAlternateDecoration() : defaultDecoration,
      child: Column(
        children: [
          Theme(
              data: ThemeData().copyWith(dividerColor: Colors.transparent),
              child: CustomExpansionTile(
                key: Key(selectedCombo?.title ?? "null"), //important for state
                initiallyExpanded: isExpanded,
                title: getTitle(),
                children: generateItems(),
                childrenPadding: EdgeInsets.zero,
                duration: Duration(milliseconds: 200),
                onExpansionChanged: _expandCallback,
                tilePadding: (widget.useFirstItemAsTitle) ? EdgeInsets.only(right: PADDING_RIGHT) : null,
                trailing: (widget.useFirstItemAsTitle)
                  ?  isTrailingCheckBox ? titleRoundedCheckBox() : item
                  : null,
              ),
          ),
          //if the item list is greater than the maxDisplayable lets consider displaying show more text
          Visibility(
              visible: canShowMoreText(),
              child: Divider(color: Colors.comboDividerColor, height: 0.5,)
          ),
          Visibility(
              visible: canShowMoreText(),
              child: SizedBox(height: 6,)
          ),
          Visibility(
              visible: canShowMoreText(),
              child: SizedBox(
                width: 110,
                child: Center(
                  child: TextButton(
                      onPressed: () => setState(() => showMore = !showMore),
                      child: Center(
                        child: Text((showMore) ? "Show Less" : "Show More",
                          style: TextStyle(
                              color: Color(0XFF3272E1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      )
                  ),
                ),
              )
          ),
          Visibility(
              visible: canShowMoreText(),
              child: SizedBox(height: 6,)
          ),
        ],
      ),
    );
  }

  bool canShowMoreText() {
    return isExpanded && copiedList.length > widget.maxDisplayValue;
  }

  void _expandCallback(bool isExpanded) {
    if(widget.useFirstItemAsTitle && selectedCombo != null) {
      ComboItem<T> currentTop = copiedList.first;
      if(currentTop != selectedCombo) {
        setState(() {
          copiedList.remove(selectedCombo);
          copiedList.insert(0, selectedCombo!);
        });
      }
    }
    showMore = true;
    if(isExpanded && selectedCombo != null) {
      setState(() {
        selectedCombo?.isSelected = false;
        this.isExpanded = true;
        selectedCombo = null;
        showMore = false;
      });
    } else if (!isExpanded && selectedCombo == null && copiedList.length > 0) {
      setState(() {
        selectedCombo = copiedList.first;
        selectedCombo?.isSelected = true;
        this.isExpanded = false;
      });
    }
    widget.onItemSelected.call(selectedCombo?.value, 0);
  }
}


enum CheckBoxPosition{
  leading, trailing
}


class ComboItem<T> {
  bool isSelected = false;
  final T value;
  final String title;
  final String? subTitle;
  final Widget? icon;
  ComboItem(this.value, this.title, {this.icon, this.isSelected = false, this.subTitle});
}