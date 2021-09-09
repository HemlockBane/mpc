import 'package:flutter/material.dart';

///@author Paul Okeke
abstract class PagedForm extends StatefulWidget {
  final _pageFormState = PageFormState(0, 0);

  int get totalItem => _pageFormState.totalItem;
  int get position => _pageFormState.position;

  void bind(int totalItem, int position) {
    _pageFormState.totalItem = totalItem;
    _pageFormState.position = position;
  }

  bool isLast() {
    return position == totalItem - 1;
  }

  String getTitle() => "NO_TITLE";

  void saveForm() {}

}

class PageFormState {
  int totalItem = 0;
  int position = 0;

  PageFormState(this.position, this.totalItem);
}