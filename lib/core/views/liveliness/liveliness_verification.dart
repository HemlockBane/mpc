import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/views/liveliness/liveliness_camera_preview.dart';
import 'package:moniepoint_flutter/core/views/liveliness/liveliness_detector.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

import '../../colors.dart';

class LivelinessVerification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LivelinessVerification();
}

class _LivelinessVerification extends State<LivelinessVerification> {
  LivelinessDetector? _livelinessDetector;

  Dialog _entryDialog() {
    print("Opening DialogZXXXXX");
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: BottomSheets.makeAppBottomSheet2(
          curveBackgroundColor: Colors.white,
          centerBackgroundPadding: 14,
          centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          contentBackgroundColor: Colors.white,
          dialogIcon: Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.primaryColor
            ),
            child: SvgPicture.asset('res/drawables/ic_face.svg'),
          ),
          content: ScrollView(
            maxHeight: 400,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  Center(
                    child: Text('BVN Face Match',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.textColorBlack)),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    'Your face needs to be verified against your BVN information. Please follow the guidelines below to ensure proper capture.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 16
                    ),
                  ),
                  SizedBox(height: 24,),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    child: Column(

                    ),
                  )
                ],
              ),
            ),
          ),
      ));
  }

  @override
  void initState() {
    _livelinessDetector = LivelinessDetector()..initialize();
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog(context: context, builder: (mContext) => _entryDialog());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Stack(
        children: [
          FutureBuilder(
              future: _livelinessDetector?.initialize(),
              builder: (mContext, value) {
                if (value.connectionState != ConnectionState.done) return Container();
                return LivelinessCameraPreview(_livelinessDetector!);
              }),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    _livelinessDetector?.dispose();
    super.dispose();
  }

}
