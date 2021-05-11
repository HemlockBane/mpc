

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class SelfieView extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final VoidCallback? onCompleted;

  SelfieView(this._scaffoldKey, {this.onCompleted});

  @override
  State<StatefulWidget> createState() {
    return _SelfieView();
  }
}

class _SelfieView extends State<SelfieView> with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void displayGuidLines() {

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Liveliness Test',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            Align(
              alignment: Alignment.center,
              child:  Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Lottie.asset('res/drawables/camera_lottie.json', repeat: true, width: 200, height: 200),
              ),
            ),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SvgPicture.asset('res/drawables/ic_info.svg'),
                  SizedBox(width: 14),
                  Expanded(child: Text('You will be asked to perform a series of random gestures which will enable us detect a live feed',
                      style: TextStyle(
                          fontFamily: Styles.defaultFont,
                          color: Colors.darkBlue,
                          fontWeight: FontWeight.w100,
                          fontSize: 14)))
                ],
              ),
            ),
            SizedBox(height: 12),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: Styles.appButton(
                  elevation: 1,
                  text: 'Start Liveliness Test', onClick: () async {
                    dynamic reference = await Navigator.pushNamed(widget._scaffoldKey.currentContext!, Routes.LIVELINESS, arguments: {
                      "bvn": viewModel.accountForm.account.bvn
                    });
                    if(reference != null) {
                      viewModel.selfieImageUUID = reference as String;
                      widget.onCompleted?.call();
                    }
                  }),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
