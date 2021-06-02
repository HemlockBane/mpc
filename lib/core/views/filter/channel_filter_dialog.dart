import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import '../../colors.dart';
import '../custom_check_box.dart';

class ChannelFilterDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ChannelFilterDialog();

}

class _ChannelFilterDialog extends State<ChannelFilterDialog> {

  final List<_ChannelFilterItem> _channelFilters = List.unmodifiable([
    _ChannelFilterItem("CARD ON ATM", TransactionChannel.ATM, "res/drawables/ic_channel_atm.svg"),
    _ChannelFilterItem("CARD ON POS", TransactionChannel.POS, "res/drawables/ic_channel_pos.svg"),
    _ChannelFilterItem("CARD ON WEB", TransactionChannel.WEB, "res/drawables/ic_channel_web.svg"),
    _ChannelFilterItem("USSD", TransactionChannel.USSD, "res/drawables/ic_channel_ussd.svg"),
    _ChannelFilterItem("MOBILE", TransactionChannel.MOBILE, "res/drawables/ic_channel_mobile.svg"),
    _ChannelFilterItem("KIOSK", TransactionChannel.KIOSK, "res/drawables/ic_channel_kiosk.svg"),
  ]);

  final List<TransactionChannel> _selectedChannels = [];

  Widget generateChannelItem(_ChannelFilterItem item, int position, OnItemClickListener<_ChannelFilterItem, int> itemClickListener) {
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
              Container(
                height: 60,
                width: 60,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: item.isSelected ? Colors.primaryColor.withOpacity(0.1) : Colors.deepGrey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(item.imageRes, color: item.isSelected ? Colors.primaryColor : null),
                ),
              ),
              SizedBox(width: 12,),
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
      height: 736,
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
              child: Text('Filter by Channel',
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
                  itemCount: _channelFilters.length,
                  itemBuilder: (context, index) {
                    return generateChannelItem(_channelFilters[index], index, _itemClickHandler);
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
                    text: 'Continue'
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void _applyFilter() {
    Navigator.of(context).pop(_selectedChannels);
  }

  bool _canApplyFilter() {
    return _selectedChannels.isNotEmpty;
  }


  void _itemClickHandler (_ChannelFilterItem item, int position) {
    setState(() {
      if(_selectedChannels.contains(item.value)) {
        item.isSelected = false;
        _selectedChannels.remove(item.value);
      }else {
        item.isSelected = true;
        _selectedChannels.add(item.value);
      }
    });
  }

}

class _ChannelFilterItem {
  final String title;
  final TransactionChannel value;
  final String imageRes;
  bool isSelected = false;

  _ChannelFilterItem(
      this.title,
      this.value,
      this.imageRes,
    { this.isSelected = false});
}