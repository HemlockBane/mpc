import 'package:flutter/material.dart';

class TransactionTab extends Container implements PreferredSizeWidget {

  TransactionTab({
    required this.tabBar,
    this.margin = const EdgeInsets.only(left: 12, right: 16)
  });

  final TabBar tabBar;
  final EdgeInsets margin;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: this.margin,
      child: tabBar,
    ),
  );


}