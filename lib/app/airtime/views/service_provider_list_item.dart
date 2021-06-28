import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
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
  Image? _itemImage;

  @override
  void initState() {
    _fetchServiceProviderLogo();
    super.initState();
  }

  void _fetchServiceProviderLogo() {
      _fileResultStream = Provider.of<ServiceProviderViewModel>(context, listen: false)
          .getFile(widget._provider.logoImageUUID ?? "");
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
                  stream: (widget._provider.logoImageUUID != null) ? _fileResultStream : null,
                  builder: (mContext, AsyncSnapshot<Resource<FileResult>> snapShot) {
                    if(!snapShot.hasData || snapShot.data == null || (snapShot.data is Error && _itemImage == null)) return Container();
                    final base64 = snapShot.data?.data;
                    final base64String = base64?.base64String;
                    if((base64 == null || base64String == null || base64String.isEmpty == true) && _itemImage == null) return Container();
                    _itemImage = (_itemImage == null)
                        ? Image.memory(base64Decode(base64String!), width: 40, height: 40, errorBuilder: (_,_i,_j) {
                          return Container();
                        })
                        : _itemImage;
                    return _itemImage!;
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