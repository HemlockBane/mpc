import 'package:flutter/material.dart';

abstract class PagedForm extends StatefulWidget {
  late final int totalItem;
  late final int position;

  void bind(int totalItem, int position) {
    this.totalItem = totalItem;
    this.position = position;
  }

  bool isLast() {
    return position == totalItem - 1;
  }

  void saveForm() {}

}