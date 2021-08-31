import 'dart:typed_data';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';

import '../bottom_sheet.dart';
import '../colors.dart';
import '../tuple.dart';

class TransactionOptionsView extends StatefulWidget {
  /// A function that returns a tuple for the download stream and the file name
  final Tuple<Stream<Uint8List> Function(), String>? displayShareReceipt;
  final Tuple<Stream<Uint8List> Function(), String>? displayDownloadReceipt;
  final bool displayReplayTransaction;
  final bool displayInitiateDispute;
  final double padding;
  final OnItemClickListener<String, int>? onItemClickListener;

  TransactionOptionsView({
    this.displayShareReceipt,
    this.displayDownloadReceipt,
    this.displayReplayTransaction = true,
    this.displayInitiateDispute = false,
    this.onItemClickListener,
    this.padding = 24
  });
  
  @override
  State<StatefulWidget> createState() => _TransactionOptionsView();
}

class _TransactionOptionsView extends State<TransactionOptionsView> {

  bool _isDownloadingShareReceipt = false;
  bool _isDownloadingReceipt = false;

  Widget initialView({Color? backgroundColor, required Widget image}) {
    return Container(
      width: 38,
      height: 38,
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? Colors.primaryColor.withOpacity(0.11)
      ),
      child: Center(
        child: image,
      ),
    );
  }

  void _downloadProgress(String title, int progress, bool isComplete) {
    switch(title.toLowerCase()) {
      case "share receipt":
        if(!_isDownloadingShareReceipt  && !isComplete) setState(() { _isDownloadingShareReceipt = true;});
        else if(_isDownloadingShareReceipt && isComplete) setState(() { _isDownloadingShareReceipt = false; });
        break;
      case "download receipt":
        if(!_isDownloadingReceipt  && !isComplete) setState(() { _isDownloadingReceipt = true;});
        else if(_isDownloadingReceipt && isComplete) setState(() { _isDownloadingReceipt = false; });
        break;
    }
  }

  void _handleDownloads(String title) async {
    try {
      switch (title.toLowerCase()) {
        case "share receipt":
          await DownloadUtil.downloadTransactionReceipt(
              widget.displayShareReceipt!.first,
              widget.displayShareReceipt!.second,
              onProgress: (progress, isComplete) => _downloadProgress(title, progress, isComplete)
          );
          break;
        case "download receipt":
          await DownloadUtil.downloadTransactionReceipt(
              widget.displayDownloadReceipt!.first,
              widget.displayDownloadReceipt!.second,
              isShare: false,
              onProgress: (progress, isComplete) => _downloadProgress(title, progress, isComplete)
          );
          break;
      }
    } catch (e) {
      setState(() { _isDownloadingReceipt = false;});
      setState(() { _isDownloadingShareReceipt = false;});
      showError(context, message: "Failed to download receipt");
    }
  }

  Widget _makeItem(String title, String res, {Color? color, Size? iconSize}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onItemClickListener?.call(title, 0),
        child: Container(
          padding: EdgeInsets.only(left: widget.padding, right: widget.padding, top: 10, bottom: 10),
          child: Row(
            children: [
              initialView(backgroundColor: color?.withOpacity(0.11),
                image: SvgPicture.asset(res, 
                  color: color ?? Colors.primaryColor, 
                  width: iconSize?.width ?? null, 
                  height: iconSize?.height ?? null,
                ),
              ),
              SizedBox(width: 16,),
              Text(title, style: TextStyle(color: Colors.textColorBlack, fontSize: 13.7, fontWeight: FontWeight.w600),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _downloadItem(String title, String res, isDownloading, {Size? size}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDownloading ? null : () => _handleDownloads(title),//onItemClickListener?.call(title, 0),
        child: Container(
          padding: EdgeInsets.only(left: widget.padding, right: widget.padding, top: 10, bottom: 10),
          child: Row(
            children: [
              Stack(
                children: [
                  if(isDownloading) SizedBox(width: 40, height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.colorPrimaryDark.withOpacity(0.5)),
                      backgroundColor: Colors.grey.withOpacity(0.1),
                    ),
                  ),
                  initialView(
                      image: SvgPicture.asset(res, width: size?.width ?? null, height: size?.height ?? null,
                      color: isDownloading ? Colors.grey.withOpacity(0.5) :Colors.primaryColor,),
                      backgroundColor: isDownloading ? Colors.grey.withOpacity(0.1) : null
                  )
                ],
              ),
              SizedBox(width: 18,),
              Text(
                title,
                style: TextStyle(
                    fontSize: 13.7, fontWeight: FontWeight.w600,
                    color: isDownloading
                        ? Colors.grey.withOpacity(0.5)
                        : Colors.textColorBlack,
                ),)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding( 
          padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
          child: Text('Options', style: TextStyle(fontSize: 13.5, color: Colors.textColorPrimary, fontWeight: FontWeight.w700),),
        ),
        SizedBox(height: 7,),
        Visibility(
            visible: widget.displayShareReceipt != null,
            child: Expanded(
                flex: 0,
                child: _downloadItem('Share Receipt', 'res/drawables/ic_share_receipt.svg', _isDownloadingShareReceipt, size: Size(22, 23))
            )),
        Visibility(
            visible: widget.displayDownloadReceipt != null,
            child: Padding(
              padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
              child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15),),
            )
        ),
        Visibility(
            visible: widget.displayDownloadReceipt != null,
            child: Expanded(
                flex: 0,
                child: _downloadItem('Download Receipt', 'res/drawables/ic_download_receipt.svg', _isDownloadingReceipt, size: Size(25, 26))
            )),
        Visibility(
            visible: widget.displayReplayTransaction,
            child: Padding(
              padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
              child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15),),
            )
        ),
        Visibility(
            visible: widget.displayReplayTransaction,
            child: Expanded(
                flex: 0,
                child: _makeItem('Replay this Transaction', 'res/drawables/ic_replay_transaction.svg', iconSize: Size(25, 25))
            )),
        Visibility(
          visible: widget.displayInitiateDispute,
          child: Expanded(
              flex: 0,
              child: Column(
                children: [
                  SizedBox(height: 180),
                  Padding(
                    padding: EdgeInsets.only(left: widget.padding, right: widget.padding),
                    child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15),),
                  ),
                   SizedBox(height: 4),
                  _makeItem('Initiate Dispute', 'res/drawables/ic_initiate_dispute.svg', 
                    iconSize: Size(18, 18), color: Color(0xffE94444)
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }


}
