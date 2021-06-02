import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';

class ServiceProviderListItem extends StatefulWidget {

  final AirtimeServiceProvider _provider;
  final int position;
  final OnItemClickListener<AirtimeServiceProvider, int>? _onItemClickListener;
  final Key key;

  ServiceProviderListItem(
      this.key,
      this._provider,
      this.position,
      this._onItemClickListener): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ServiceProviderItem();
  }

}

class _ServiceProviderItem extends State<ServiceProviderListItem> {

  @override
  void initState() {
    super.initState();
  }

  void _onSelected() {
    // final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    // pattern.allMatches(widget._provider.svgImage ?? "").forEach((match) => print(match.group(0)));
    widget._onItemClickListener?.call(widget._provider, widget.position);
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: _onSelected,
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 16, top: 4, bottom: 4),
        child: Row(
          children: [
            Visibility(
                visible: widget._provider.svgImage != null,
                child: SvgPicture.string(widget._provider.svgImage ?? ""),
            ),
            Expanded(
                child: Text(
                    widget._provider.name ?? "",
                    style: TextStyle(fontSize: 15, color: (widget._provider.isSelected == true)
                        ? Colors.primaryColor
                        : Colors.dividerColor2,
                      fontFamily: Styles.defaultFont,
                      fontWeight: FontWeight.normal
                    ))
            ),
            SizedBox(width: 8),
            CustomCheckBox(onSelect: (bool a) {
              _onSelected();
            }, isSelected: widget._provider.isSelected == true),
            SizedBox(width: 8),
          ],
        ),
      ),
    ),
  );
}