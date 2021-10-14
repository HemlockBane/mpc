import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';

import '../../colors.dart';
import '../../custom_fonts.dart';
import '../custom_check_box.dart';

class DateFilterDialog extends StatefulWidget {

  final String dialogTitle;
  final String? dialogIcon;

  DateFilterDialog({this.dialogTitle = "Filter by Date", this.dialogIcon});

  @override
  State<StatefulWidget> createState() => _DateFilterDialog();

}

class _DateFilterDialog extends State<DateFilterDialog> {

  static const LAST_7DAYS = 7;
  static const LAST_14DAYS = 14;
  static const LAST_MONTH = 30;
  static const LAST_QUARTER = LAST_MONTH * 3;
  static const LAST_YEAR = 365;
  static const CUSTOM = -1;

  late final List<_DateFilterItem> dateFilters;
  final TextEditingController _startAndEndDateController = TextEditingController();

  _DateFilterItem? _selectedItem;
  int? selectedStartDate = 0;
  int? selectedEndDate = 0;

  final List<int> dateRanges = List.unmodifiable([
    LAST_7DAYS, LAST_14DAYS, LAST_MONTH, LAST_QUARTER, LAST_YEAR, CUSTOM
  ]);

  _DateFilterDialog() {
    this.dateFilters = makeList();
  }

  List<_DateFilterItem> makeList() {
    return dateRanges.map((e) {
      if (e == CUSTOM) return _DateFilterItem('Custom Date', '', 0, 0);
      final endDate = DateTime.now().millisecondsSinceEpoch;
      final startDate = DateTime.now().subtract(Duration(days: e)).millisecondsSinceEpoch;
      final dateString = getDateString(startDate, endDate);
      if (e == LAST_QUARTER) {
        return _DateFilterItem('Last Quarter', dateString, startDate, endDate);
      } else if (e == LAST_MONTH) {
        return _DateFilterItem('Last Month', dateString, startDate, endDate);
      } else if (e == LAST_YEAR) {
        return _DateFilterItem('Last Year',
            getDateString(startDate, endDate, format: "yyyy"),
            startDate,
            endDate
        );
      }
      return _DateFilterItem('Last $e days', dateString, startDate, endDate);
    }).toList();
  }

  String getDateString(int startDate, int endDate, {String format="d MMM"}) {
    return "${DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(startDate))} "
        "- ${DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(endDate))}";
  }

   Widget generateDateItem(_DateFilterItem item, int position, OnItemClickListener<_DateFilterItem, int> itemClickListener) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          item.title,
                          style: TextStyle(fontSize: 16, color: Colors.colorPrimaryDark,
                              fontFamily: Styles.defaultFont,
                              fontWeight: FontWeight.normal
                          )),
                      Visibility(
                          visible: item.dateString.isNotEmpty,
                          child: Text(item.dateString, style: TextStyle(color: Colors.deepGrey, fontSize: 14),)
                      )
                    ],
                  )
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
      height: _selectedItem?.title.toLowerCase() == "custom date" ? 800 : 736,
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerImageRes: widget.dialogIcon ?? 'res/drawables/ic_date_dialog_calendar.svg',
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
                  child: Text(widget.dialogTitle,
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
                      itemCount: dateFilters.length,
                      itemBuilder: (context, index) {
                        return generateDateItem(dateFilters[index], index, _itemClickHandler);
                      },
                    )
                ),
                SizedBox(height: 12),
                Visibility(
                    visible: _selectedItem?.title.toLowerCase() == "custom date",
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: Styles.appEditText(
                        controller: _startAndEndDateController,
                        hint: 'Start and End date',
                        startIcon: Icon(
                            CustomFont.calendar,
                            color: Colors.colorFaded,
                          ),
                        enabled: false,
                        onClick: () => displayDatePicker(context),
                    ),
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

  void displayDatePicker(BuildContext context) async {
    final selectedDate = await showDateRangePicker(
        helpText: 'Select Start and End Date',
        context: context,
        firstDate: DateTime(1900, 1, 1).add(Duration(days: 1)),
        lastDate: DateTime.now()
    );

    if(selectedDate != null ) {
      setState(() {
        selectedStartDate = selectedDate.start.millisecondsSinceEpoch;
        selectedEndDate = selectedDate.end.add(Duration(hours: 23)).millisecondsSinceEpoch;
        _startAndEndDateController.text =
            getDateString(selectedStartDate ?? 0, selectedEndDate ?? 0);
      });
    }
  }

  void _applyFilter() {
    Navigator.of(context).pop(Tuple(selectedStartDate, selectedEndDate));
  }

  bool _canApplyFilter() {
    return selectedStartDate != null
        && selectedStartDate != 0
        && selectedEndDate != null
        && selectedEndDate !=  0;
  }


  void _itemClickHandler (_DateFilterItem item, int position) {
    setState(() {
      _selectedItem?.isSelected = false;
      item.isSelected = !item.isSelected;
      _selectedItem = item;

      if(item.title.toLowerCase() == "custom date") {
        _startAndEndDateController.text = "";
        selectedStartDate = 0;
        selectedEndDate = 0;
        //user must select a date
        return;
      }
      selectedStartDate = item.startDate;
      selectedEndDate = item.endDate;
    });
  }

}

class _DateFilterItem {
  final String title;
  final String dateString;
  final int startDate;
  final int endDate;
  bool isSelected = false;

  _DateFilterItem(
      this.title,
      this.dateString,
      this.startDate,
      this.endDate, { this.isSelected = false});
}