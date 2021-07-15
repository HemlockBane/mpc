import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Liveliness2 extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  Liveliness2(this._scaffoldKey);


  @override
  State<StatefulWidget> createState() => _Liveliness2();
}

class _Liveliness2 extends State<Liveliness2> {
  static const platform = const MethodChannel('moniepoint.flutter.dev/liveliness');
  static const eventChannel = const EventChannel('moniepoint.flutter.dev/liveliness/events');

  int? _cameraId;
  Future<dynamic>? cameraFuture;

  @override
  void initState() {
    _startCamera();
    super.initState();

    cameraFuture?.whenComplete(() async {
      print("Initializing liveliness from flutter");
      await platform.invokeMethod("start");
      print("Listening from stream");

      eventChannel.receiveBroadcastStream().listen((event) async {
        final map = event as Map<dynamic, dynamic>;
        final eventType = map["event_type"];
        if(eventType == "MotionDetectedEvent") {
          final filePath = map["file_path"];
          final dir = await getTemporaryDirectory();
          final file = File(join(dir.path, "motion_resized.jpg"));
          final compressedByte = await FlutterImageCompress.compressWithFile(filePath, minWidth: 300, minHeight: 300);
          if(compressedByte != null) file.writeAsBytes(compressedByte);
        }
      });
    });
  }

  void _startCamera() async {
    cameraFuture = platform.invokeMethod("create");
    final result = await cameraFuture;
    final data = result as Map<dynamic, dynamic>;
    _cameraId = data["cameraId"];
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return FutureBuilder(
        future: cameraFuture,
        builder: (mContext, AsyncSnapshot<dynamic> v) {
          if(v.connectionState != ConnectionState.done) return Container();
          print("Camera ID is $_cameraId");
          return Container(
            child: SizedBox(
              child: AspectRatio(
                aspectRatio: 4/3,
                child: Texture(textureId: _cameraId!),
              )
            ),
          );
        }
    );
  }
}