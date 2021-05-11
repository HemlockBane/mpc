import 'dart:io';

import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class SignatureView extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final VoidCallback? onCompleted;

  SignatureView(this._scaffoldKey, {this.onCompleted});

  @override
  State<StatefulWidget> createState() {
    return _SignatureView();
  }
}

class _SignatureView extends State<SignatureView> with AutomaticKeepAliveClientMixin {

  final SignatureController _signatureController = SignatureController(penStrokeWidth: 1, penColor: Colors.darkBlue);
  File? _signatureFile;

  bool _isLoading = false;
  bool _hasSigned = false;

  @override
  void initState() {
    super.initState();
    _signatureController.addListener(() {
      setState(() {});
    });
  }

  Widget _buildSignatureView() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 45),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.deepGrey.withOpacity(0.29), width: 1.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Signature(
                height: 400,
                controller: _signatureController,
                backgroundColor: Colors.white,
              )),
        ),
        Positioned(
            right: 45 + 16,
            top: 16,
            child: Transform.rotate(
                angle: 0,
                child: GestureDetector(
                  onTap: (){
                    changeScreenOrientation();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 15,
                            color: Colors.black.withOpacity(0.2),
                            offset: Offset(0, 10),
                          )
                        ]),
                    child: SvgPicture.asset(
                        'res/drawables/ic_signature_rotate.svg')
                ),)
            )),
        Positioned(
            right: 45 + 12,
            bottom: 12,
            child: Opacity(
              opacity: _signatureController.isEmpty ? 0 : 1,
              child: TextButton(
                  child: Text('CLEAR',
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.deepGrey, fontSize: 14)),
                  onPressed: () {
                    _signatureController.clear();
                  }),
            ))
      ],
    );
  }

  void changeScreenOrientation() {
    final currentOrientation = MediaQuery.of(context).orientation;
    final newOrientation =  (currentOrientation == Orientation.portrait)
        ? Orientation.landscape
        : Orientation.portrait;

    _signatureController.clear();

    if (newOrientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
      );
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
      );
    }
  }

  void handleUploadResponse<T>(Resource<T> resource) {
    if(resource is Success<T>) {
      setState(() => _isLoading = false);
      _signatureFile?.delete();
      widget.onCompleted?.call();
    } else if(resource is Error<T>) {
      showModalBottomSheet(
          context: widget._scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: resource.message);
          });
      setState(() => _isLoading = false);
    }
    else if (resource is Loading) setState(() => _isLoading = true);
  }


  void _onCaptureSignature() async {
    //let's first save the signature
    if(await Permission.storage.request().isGranted) {
     final bytes = await _signatureController.toPngBytes();
     Directory dir = await getTemporaryDirectory();
     _signatureFile = File(join(dir.path, 'signature.png'));
     _signatureFile?.writeAsBytesSync(bytes!);

     final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
      viewModel
          .uploadSignature(_signatureFile?.path ?? "")
          .listen(handleUploadResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sign in the space below',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _buildSignatureView(),
            Spacer(),
            SizedBox(height: 32),
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        text: 'Continue',
                        onClick: (_isLoading || _signatureController.isEmpty)
                            ? null
                            : _onCaptureSignature),
                  ),
                  Positioned(
                      right: 16,
                      top: 16,
                      bottom: 16,
                      child: _isLoading
                          ? SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.5))
                          : SizedBox())
                ],
              ),
            ),
            SizedBox(height: 63)
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
