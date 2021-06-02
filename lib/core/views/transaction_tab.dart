import 'package:flutter/material.dart';

class TransactionTab extends Container implements PreferredSizeWidget {

  TransactionTab(this._tabBar, this._color);

  final TabBar _tabBar;
  final Color _color;

  @override
  Size get preferredSize => _tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(right: 16, left: 16),
    height: 40,
    decoration: BoxDecoration(
      color: _color,
      borderRadius: BorderRadius.circular(50)
    ),
    child: _tabBar,
  );


}