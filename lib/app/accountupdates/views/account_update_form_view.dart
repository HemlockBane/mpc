import 'package:flutter/material.dart';

abstract class PagedForm extends StatefulWidget {
  int totalItem = 0;
  int position = 0;

  void bind(int totalItem, int position) {
    this.totalItem = totalItem;
    this.position = position;
  }

  bool isLast() {
    return position == totalItem - 1;
  }

  void saveForm() {}

}