import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class TransactionSuccessDialog extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TransactionSuccessDialog();

}

class _TransactionSuccessDialog extends State<TransactionSuccessDialog> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callMethod();
  }

  void callMethod () async {
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
    print('initialized successfully');
    final dir = await getExternalStorageDirectories(type: StorageDirectory.downloads);
    dir?.forEach((element) {
      print(element.path);
    });
    // print(dir?.path);
    // FlutterDownloader.registerCallback(callback);
    // String? value = await FlutterDownloader.enqueue(
    //     url: 'https://www.americanexpress.com/content/dam/amex/us/staticassets/pdf/GCO/Test_PDF.pdf',
    //     savedDir: dir?.path ?? ""
    // );
    //
    // print("Something about task $value");
  }

  static void callback (String id, DownloadTaskStatus status, int progress) {
    print(progress);
    print("Download Status ${status.value}");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

}