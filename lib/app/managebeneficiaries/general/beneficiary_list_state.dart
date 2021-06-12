import 'package:flutter/material.dart';

abstract class BeneficiaryListState<T extends StatefulWidget> extends State<T> with AutomaticKeepAliveClientMixin{

  String _searchValue = "";
  String get searchValue => _searchValue;

  void updateSearch(String searchValue) {
    this._searchValue = searchValue;
    searchBeneficiary();
  }

  void searchBeneficiary();

  @override
  bool get wantKeepAlive => true;

}