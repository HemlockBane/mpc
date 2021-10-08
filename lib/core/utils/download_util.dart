import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:collection/collection.dart';

class DownloadUtil {

  static Future<void> downloadTransactionReceipt(
      Stream<Uint8List> Function() downloadTask, String fileName,
      {bool isShare = true, Function(int progress, bool isCompleted)?  onProgress}) async {

    if(!(await Permission.storage.request().isGranted)) return;

    int progress = 5;//0-100

    onProgress?.call(progress, false);

    List<int> chunks = [];
    await for (Uint8List a in downloadTask.call()) {
      chunks.addAll(a);
      progress = min(progress + 10, 100);
      onProgress?.call(progress - 1, false);
    }

    final File file;

    if(Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File("${dir.path}/$fileName");
    } else {
      file = File("/storage/emulated/0/Download/$fileName");
    }

    await file.writeAsBytes(chunks);
    onProgress?.call(100, true);

    if(isShare) {
      await Share.shareFiles([file.path], );
    } else {
      await OpenFile.open(file.path);
    }
  }

  static Future<void> downloadFileResult(
      Stream<Resource<FileResult>> Function() downloadTask, String fileName,
      {bool isShare = true, Function(int progress, bool isCompleted)? onProgress}) async {

    if(!(await Permission.storage.request().isGranted)) return;

    int progress = 5;

    onProgress?.call(progress, false);

    List<int> chunks = [];
    String? fileType;

    await for (Resource<FileResult> resource in downloadTask.call()) {
      if(resource is Loading) {
        onProgress?.call(progress, false);
        if(resource.data != null) {
          final base64String = resource.data?.base64String;
          fileType = resource.data?.contentType;
          if(base64String == null) return;
          chunks = base64.decode(base64String).map((value) => value).toList();
        }
      }
      else if(resource is Success) {
        final base64String = resource.data?.base64String;
        fileType = resource.data?.contentType;
        if(base64String == null) return;
        chunks = base64.decode(base64String).map((value) => value).toList();
        break;
      } else if(resource is Error<FileResult>) {
        throw Exception(resource.message);
        // break;
      }
    }

    final File file;
    String mFileName = fileName;

    if(fileType != null) {
      final extension = (fileType.contains("image/pnd")) ? ".pnd"
          : (fileType.contains("pdf")) ? ".pdf" : ".jpg";
      if(extension.isNotEmpty) mFileName = "preview$extension";
    }

    if(Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      file = File("${dir.path}/$mFileName");
    } else {
      file = File("/storage/emulated/0/Download/$mFileName");
    }

    await file.writeAsBytes(chunks);
    onProgress?.call(100, true);

    if(isShare) {
      await Share.shareFiles([file.path], );
    } else {
      await OpenFile.open(file.path);
    }
  }


  static Image? downloadImageWithUUID(String? uuid) {
    if(uuid == null) return null;
    final url = "${ServiceConfig.OPERATION_SERVICE}api/v1/file-management/get-file?fileUUID=$uuid";
    final headers = {"Authorization" : "Bearer ${UserInstance().getUser()?.accessToken}"};
    return Image.network(url, headers: headers,);
  }

}