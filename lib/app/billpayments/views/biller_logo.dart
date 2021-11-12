import 'dart:convert';

import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/billpayments/model/data/biller.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

class BillerLogo extends StatefulWidget {

  BillerLogo({
    Key? key,
    required this.biller,
    required this.fileStreamFn
  }):super(key: key);

  final Biller biller;
  final Stream<Resource<FileResult>> Function(String logoId) fileStreamFn;

  @override
  State<StatefulWidget> createState() => _BillerLogoState();

}

class _BillerLogoState extends State<BillerLogo> {

  Stream<Resource<FileResult>>? _fileResultStream;
  Image? _itemImage;

  @override
  void initState() {
    _fetchBillerLogo();
    super.initState();
  }

  void _fetchBillerLogo() {
    _fileResultStream = widget.fileStreamFn.call(widget.biller.logoImageUUID ?? "");
  }

  Widget _defaultImage() {
    return Container(
      width: 34,
      height: 34,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaryColor.withOpacity(0.1)),
      child: Center(
        child: Container(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(widget.biller.logoImageUUID == null) return _defaultImage();
    return Visibility(
      visible: widget.biller.logoImageUUID != null,
      child: StreamBuilder(
          stream: _fileResultStream,
          builder: (mContext, AsyncSnapshot<Resource<FileResult>> snapShot) {
            if(!snapShot.hasData || snapShot.data == null || (snapShot.data is Error && _itemImage == null)) return _defaultImage();
            final base64 = snapShot.data?.data;
            final base64String = base64?.base64String;
            if((base64 == null || base64String == null || base64String.isEmpty == true) && _itemImage == null) return _defaultImage();
            _itemImage = (_itemImage == null)
                ? Image.memory(base64Decode(base64String!), width: 40, height: 40, errorBuilder: (_,_i,_j) {
                    return Container();
                  })
                : _itemImage;
            return _itemImage!;
          }
      ),
    );
  }

}