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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startCamera();
  }

  void _startCamera() async {
    await platform.invokeMethod("analyzeImage");
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}