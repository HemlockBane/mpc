import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Liveliness2 extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  Liveliness2(this._scaffoldKey);


  @override
  State<StatefulWidget> createState() => _Liveliness2();
}

class _Liveliness2 extends State<Liveliness2> {
  static const platform = const MethodChannel('moniepoint.flutter.dev/liveliness');

  int? _cameraId;
  Future<dynamic>? cameraFuture;

  @override
  void initState() {
    _startCamera();
    super.initState();

    cameraFuture?.whenComplete(() async {
      print("Initializing liveliness from flutter");
      await platform.invokeMethod("initialize");
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