import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

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
  ReceivePort _receivePort = ReceivePort();
  
  final String androidDownloadPath = "/storage/emulated/0/Download/";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "transaction_receipt");
    _receivePort.listen((a) => _onDownloadCallback(a as List<dynamic>));
    callMethod();
  }

  void _onDownloadCallback(List<dynamic> data) {
    final downloadTaskStatus = data[1] as DownloadTaskStatus;
    if(downloadTaskStatus == DownloadTaskStatus.complete) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
      Share.shareFiles(["$androidDownloadPath/${widget.successPayload.fileName}"], text: 'Receipt');
    }
    if(downloadTaskStatus == DownloadTaskStatus.running || downloadTaskStatus == DownloadTaskStatus.enqueued) {
      setState(() {
        _isLoading = true;
      });
    } else if(downloadTaskStatus == DownloadTaskStatus.failed) {
      setState(() {
        _isLoading = false;
      });
      print("This is the error $data");
      Navigator.of(context).pop();
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          context: context,
          builder: (mContext) => BottomSheets.displayErrorModal(mContext, message: "Failed to download receipt")
      );
    }
  }

  void callMethod () async {
    FlutterDownloader.registerCallback(downloadReceiptCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('transaction_receipt');
    super.dispose();
  }

  void _startDownload() async {
    if(await Permission.storage.request().isGranted) {
      FlutterDownloader.enqueue(
        url: widget.successPayload.downloadUrl ?? "",
        savedDir: (Platform.isAndroid) ? androidDownloadPath : (await getApplicationDocumentsDirectory()).path,
        showNotification: true,
        fileName: widget.successPayload.fileName ?? "Moniepoint_(${DateTime.now().millisecondsSinceEpoch}).pdf",
        headers: {
          "client-id": BuildConfig.CLIENT_ID,
          "appVersion": BuildConfig.APP_VERSION,
          "Authorization": "bearer ${UserInstance().getUser()!.accessToken}"
        },
        // show download progress in status bar (for Android)
        openFileFromNotification: true,
      );
    }
  }

  static void downloadReceiptCallback (String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('transaction_receipt');
    send?.send([id, status, progress]);
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
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidDarkGreen),
                    child: Text(widget.successPayload.message,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white
                        ), textAlign: TextAlign.center),
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
                      visible: !_isLoading,
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
  final String? downloadUrl;
  final String? fileName;

  SuccessPayload(this.title, this.message,{this.token,  this.downloadUrl, this.fileName});
}