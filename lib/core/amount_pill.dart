import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class AmountPill extends StatefulWidget {

  final ListDataItem<String> _item;
  final OnItemClickListener<ListDataItem<String>, int> _listener;
  final int _position;

  AmountPill(
      this._item,
      this._position,
      this._listener);

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
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            color: (widget._item.isSelected == true) ? Colors.primaryColor : Colors.white,
            border: Border.all(color: Colors.colorFaded.withOpacity(0.5), width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Center(
          child: Text(
              widget._item.item,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: (widget._item.isSelected == true)
                      ? Colors.white
                      : Colors.primaryColor,
                  fontWeight: (widget._item.isSelected == true) ? FontWeight.bold : FontWeight.w600
              )),
        ),
      ),
    );
  }

}