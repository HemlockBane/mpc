
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';
import 'package:moniepoint_flutter/main.dart';

import '../colors.dart';
import '../styles.dart';

class TransactionSuccessPage extends StatefulWidget {

  final SuccessPayload successPayload;
  final VoidCallback? onClick;

  final Widget? content;
  final String primaryButtonText;

  TransactionSuccessPage(this.successPayload, {
    this.onClick,
    Key? key,
    this.content,
    this.primaryButtonText = "Continue",
  }): super(key: key);

  @override
  State<StatefulWidget> createState() => _TransactionSuccessPage();

}

class _TransactionSuccessPage extends State<TransactionSuccessPage> {

  final String androidDownloadPath = "/storage/emulated/0/Download/";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

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
        showError(
            context,
            title: "Download Receipt Failed!",
            message: "Failed to download receipt, please try again later."
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _tokenView() {
    if(widget.successPayload.token == null) return SizedBox();
    return Container(
      padding: EdgeInsets.only(left: 15, right: 8, top: 17, bottom: 17),
      decoration: BoxDecoration(
        color: Colors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Meter Token:',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.textColorMainBlack),
              ),
              SizedBox(height: 4,),
              Text(
                widget.successPayload.token ?? "",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.textColorBlack),
              )
            ],
          )),
          _copyToken()
        ],
      ),
    );
  }

  Widget _copyToken() {
    return TextButton.icon(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: widget.successPayload.token ?? ""));
          ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
              SnackBar(content: Text("Copied to Clipboard!"))
          );
        },
        icon: SvgPicture.asset('res/drawables/ic_copy_full.svg', color: Colors.primaryColor,),
        label: Text('Copy', style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w500, fontSize: 15),)
    );
  }

  TextStyle getBoldStyle(
      {double fontSize = 32.5,
        Color color = Colors.white,
        FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
      {double fontSize = 32.5,
        Color color = Colors.textColorBlack,
        FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Container(
                  height: 60,
                  width: 60,
                  padding: EdgeInsets.all(13),
                  child: SvgPicture.asset(
                    "res/drawables/ic_circular_check_mark.svg",
                    color: Colors.white,
                  ),
                  decoration:
                  BoxDecoration(
                      color: Colors.solidGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Color(0XFF2EB019).withOpacity(0.38),
                            offset: Offset(0, 8),
                            blurRadius: 22
                        )
                      ]
                  ),
                ),
                SizedBox(height: 37),
                Text(
                  widget.successPayload.title,
                  style: getBoldStyle(color: Colors.solidGreen, fontSize: 32),
                ),
                SizedBox(height: 28),
                Text(widget.successPayload.message, style: getNormalStyle(fontSize: 15)),
                SizedBox(height: 27),
                SizedBox(height: widget.successPayload.token != null ? 27 : 0,),
                _tokenView(),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      elevation: 0.3,
                      buttonStyle: Styles.savingsFlexButtonStyle,
                      onClick: _isLoading ? null : widget.onClick ?? () => Navigator.of(context).pop(),
                      text: widget.primaryButtonText
                  ),
                ),
                SizedBox(height: 35),
                Visibility(
                    visible: !_isLoading && widget.successPayload.downloadTask != null,
                    child: GestureDetector(
                      onTap: () => _startDownload(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('res/drawables/ic_share.svg', color: Colors.solidGreen),
                          SizedBox(width: 8),
                          Text(
                            'Share Receipt',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.solidGreen,
                                fontWeight: FontWeight.w700
                            ),
                          )
                        ],
                      ),
                    )),
                Visibility(
                    visible: _isLoading,
                    child: SpinKitThreeBounce(size: 20.0, color: Colors.solidGreen.withOpacity(0.9))
                ),
                SizedBox(height: 56)
              ],
            ),
          ),
        ),
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