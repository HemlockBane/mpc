import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import '../../colors.dart';
import '../custom_check_box.dart';
import 'package:collection/collection.dart';

class TransactionTypeFilterDialog extends StatefulWidget {

  final List<TransactionType>? selectedTypes;

  TransactionTypeFilterDialog({this.selectedTypes});

  @override
  State<StatefulWidget> createState() => _TransactionTypeFilterDialog();

}

class _TransactionTypeFilterDialog extends State<TransactionTypeFilterDialog> {

  final List<_TransactionTypeFilterItem> _typeFilters = List.unmodifiable([
    _TransactionTypeFilterItem("All", TransactionType.ALL),
    _TransactionTypeFilterItem("Credit", TransactionType.CREDIT),
    _TransactionTypeFilterItem("Debit", TransactionType.DEBIT),
  ]);

  final List<TransactionType> _selectedTypes = [];
  _TransactionTypeFilterItem? _selectedType;

  @override
  void initState() {
    _setDefaultValues();
    super.initState();
  }

  void _setDefaultValues() {
    final selectedTypes = widget.selectedTypes;
    if(selectedTypes == null) return _selectAllAsDefault();
    _typeFilters.forEach((element) {
      if(selectedTypes.contains(element.value)) {
        element.isSelected = true;
        _selectedType = element;
        _selectedTypes.add(element.value);
      }
    });

    if(_typeFilters.isEmpty) _selectAllAsDefault();
  }

  void _selectAllAsDefault() {
    _typeFilters.firstOrNull?.isSelected = true;
    _selectedType = _typeFilters.firstOrNull;
  }

  Widget generateChannelItem(_TransactionTypeFilterItem item, int position, OnItemClickListener<_TransactionTypeFilterItem, int> itemClickListener) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        onTap: () => itemClickListener.call(item, position),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                      item.title,
                      style: TextStyle(fontSize: 16, color: item.isSelected ? Colors.colorPrimaryDark : Colors.deepGrey,
                          fontFamily: Styles.defaultFont,
                          fontWeight: FontWeight.normal
                      ))
              ),
              SizedBox(width: 8),
              CustomCheckBox(onSelect: (bool a) {
                itemClickListener.call(item, position);
              }, isSelected: item.isSelected == true),
              SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
      height: 510,
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerImageRes: 'res/drawables/ic_filter_type.svg',
      centerImageHeight: 18,
      centerImageWidth: 18,
      centerBackgroundHeight: 74,
      centerBackgroundWidth: 74,
      centerBackgroundPadding: 20,
      content: Container(
        padding: EdgeInsets.only(bottom: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 22),
            Center(
              child: Text('Filter by Type',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.colorPrimaryDark)),
            ),
            SizedBox(height: 20),
            Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Divider(color: Color(0XFFE0E0E0), height: 1,),
                  ),
                  itemCount: _typeFilters.length,
                  itemBuilder: (context, index) {
                    return generateChannelItem(_typeFilters[index], index, _itemClickHandler);
                  },
                )
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SizedBox(
                width: double.infinity,
                child: Styles.appButton(
                    elevation: _canApplyFilter() ? 0.5 : 0,
                    onClick:  _canApplyFilter() ? _applyFilter : null,
                    text: 'Apply Filter'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _applyFilter() {
    Navigator.of(context).pop(_selectedTypes);
  }

  bool _canApplyFilter() {
    return _selectedType?.value == TransactionType.ALL || _selectedTypes.isNotEmpty;
  }

  void _itemClickHandler (_TransactionTypeFilterItem item, int position) {
    setState(() {
      _selectedType?.isSelected = false;
      item.isSelected = !item.isSelected;
      _selectedType = item;

      _selectedTypes.clear();
      if(item.value != TransactionType.ALL) {
        _selectedTypes.add(item.value);
      }
    });
  }

}

class _TransactionTypeFilterItem {
  final String title;
  final TransactionType value;
  bool isSelected = false;

  _TransactionTypeFilterItem(
      this.title,
      this.value,
    { this.isSelected = false});
}