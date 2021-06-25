import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/customer/account_provider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:provider/provider.dart';

class ServiceProviderListItem extends StatefulWidget {

  final AirtimeServiceProvider _provider;
  final int position;
  final OnItemClickListener<AirtimeServiceProvider, int>? _onItemClickListener;
  final Key key;

  ServiceProviderListItem(
      this.key,
      this._provider,
      this.position,
      this._onItemClickListener,
  ) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ServiceProviderItem();

}

class _ServiceProviderItem extends State<ServiceProviderListItem> {

  Stream<Resource<FileResult>>? _fileResultStream;

  @override
  void initState() {
    _fileResultStream = Provider.of<ServiceProviderViewModel>(context, listen: false)
        .getFile(widget._provider.logoImageUUID ?? "");
    super.initState();
  }

  void _onSelected() {
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
              visible: widget._provider.logoImageUUID != null,
              child: StreamBuilder(
                  stream: _fileResultStream,
                  builder: (mContext, AsyncSnapshot<Resource<FileResult>> snapShot) {
                    if(!snapShot.hasData || snapShot.data == null) return Container();
                    final base64 = snapShot.data?.data;
                    final base64String = base64?.base64String;
                    if(base64 == null || base64String == null || base64String.isEmpty == true) return Container();
                    return Image.memory(base64Decode(base64.base64String!), width: 40, height: 40,);
                  }
              ),
            ),
            SizedBox(width: 8,),
            Expanded(
                child: Text(
                    widget._provider.name ?? "",
                    style: TextStyle(
                        fontSize: 15,
                        color: (widget._provider.isSelected == true)
                            ? Colors.primaryColor
                            : Colors.dividerColor2,
                        fontFamily: Styles.defaultFont,
                        fontWeight: FontWeight.normal
                    )
                )
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