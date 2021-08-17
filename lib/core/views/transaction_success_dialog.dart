
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';

import '../colors.dart';
import '../styles.dart';

class TransactionSuccessDialog extends StatefulWidget {

  final SuccessPayload successPayload;
  final VoidCallback? onClick;

  TransactionSuccessDialog(this.successPayload, {this.onClick});

  @override
  State<StatefulWidget> createState() => _TransactionSuccessDialog();

}

class _TransactionSuccessDialog extends State<TransactionSuccessDialog> {

  final String androidDownloadPath = "/storage/emulated/0/Download/";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _startDownload() async {
    final fileName = widget.successPayload.fileName;
    final downloadTask = widget.successPayload.downloadTask;
    if(fileName != null && downloadTask != null) {
      setState(() { _isLoading = true; });
      try {
        final _a = await DownloadUtil.downloadTransactionReceipt(() =>
            downloadTask.call(), fileName
        );
        setState(() { _isLoading = false; });
      } catch(e) {
        setState(() { _isLoading = false; });
        showError(context, message: "Failed to download receipt");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tokenView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'METER TOKEN:',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white),
        ),
        Text(
          widget.successPayload.token ?? "",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        )
      ],
    );
  }

  Widget _copyToken() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white.withOpacity(0.01)
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.white.withOpacity(0.1),
          overlayColor: MaterialStateProperty.all(Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(4),
          onTap: () => Clipboard.setData(ClipboardData(text: widget.successPayload.token ?? "")),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                SvgPicture.asset('res/drawables/ic_copy.svg', color: Colors.white,),
                SizedBox(height: 4,),
                Text('COPY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.solidGreen,
        centerImageBackgroundColor: Colors.white,
        contentBackgroundColor: Colors.solidGreen,
        centerImageRes: 'res/drawables/success_modal_check.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(widget.successPayload.title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      )
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              color: Colors.solidDarkGreen
                          ),
                          child: widget.successPayload.token == null
                              ? Text(widget.successPayload.message,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white
                              ), textAlign: TextAlign.center
                          )
                              : _tokenView()
                      )),
                      SizedBox(width: widget.successPayload.token != null ? 12 : 0,),
                      Visibility(
                          visible: widget.successPayload.token != null,
                          child: _copyToken()
                      )
                    ],
                  ),
                  SizedBox(height: 21),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          onClick: widget.onClick ?? () => Navigator.of(context).pop(),
                          text: 'Continue',
                          buttonStyle: Styles.whiteButtonStyle.copyWith(
                              foregroundColor: MaterialStateProperty.all(Colors.solidGreen))
                      )
                  ),
                  SizedBox(height: 32),
                  Visibility(
                      visible: !_isLoading && widget.successPayload.downloadTask != null,
                      child: GestureDetector(
                        onTap: () => _startDownload(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('res/drawables/ic_share.svg'),
                            SizedBox(width: 8,),
                            Text(
                              'Share Receipt'.toUpperCase(),
                              style: TextStyle(fontSize: 14, color: Colors.white),
                            )
                          ],
                        ),
                      )
                  ),
                  Visibility(
                      visible: _isLoading,
                      child: SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.9))
                  ),
                  SizedBox(height: 40)
                ],
              ),
            )
          ],
        )
    );
  }


}

class SuccessPayload {
  final String title;
  final String message;
  final String? token;
  final String? fileName;
  final Stream<Uint8List> Function()? downloadTask;

  SuccessPayload(this.title, this.message, {this.token, this.fileName, this.downloadTask});
}