import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class AmountPill extends StatefulWidget {

  final ListDataItem<String> _item;
  final OnItemClickListener<ListDataItem<String>, int> _listener;
  final int _position;
  final Color primaryColor;

  AmountPill(
  {required ListDataItem<String> item,
    required int position,
    required OnItemClickListener<ListDataItem<String>, int> listener,
      this.primaryColor = Colors.primaryColor}
    ): _item = item, _position = position, _listener = listener;

  @override
  State<StatefulWidget> createState() {
    return _AmountPill();
  }

}

class _AmountPill extends State<AmountPill> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget._listener.call(widget._item, widget._position),
      child: Container(
        padding: EdgeInsets.only(left: 9, right: 9, top: 9, bottom: 9),
        decoration: BoxDecoration(
            color: (widget._item.isSelected == true) ? widget.primaryColor : Colors.white,
            border: Border.all(color: Colors.colorFaded.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Center(
          child: Text(
              widget._item.item,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  color: (widget._item.isSelected == true)
                      ? Colors.white
                      : widget.primaryColor,
                  fontWeight: (widget._item.isSelected == true) ? FontWeight.bold : FontWeight.w600
              )),
        ),
      ),
    );
  }

}