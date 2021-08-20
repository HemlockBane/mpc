import 'dart:async';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_linking_response.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_activation_code_dialog.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CardQRCodeScannerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardQRCodeScannerViewState();
}
enum CardLinkMode {
  QR_CODE, CARD_SERIAL
}
class _CardQRCodeScannerViewState extends State<CardQRCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? _result;
  String? _cardSerial;
  QRViewController? _qrViewController;

  CardLinkMode _cardLinkMode = CardLinkMode.QR_CODE;
  bool _isCardSerialValid = false;
  TextEditingController? _cardSerialController;
  StreamSubscription? _qrCodeStreamSubscription;


  initState() {
    _cardSerialController = TextEditingController();
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (mContext) => _displayScanBarcodeDialog()
      );
    });
  }

  Future<bool> _requestCameraPermission() async {
    if(await Permission.camera.request().isGranted) {
      return true;
    } else {
      Navigator.of(context).pop();
    }
    return false;
  }

  Dialog _displayScanBarcodeDialog() {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BottomSheets.makeAppBottomSheet2(
          curveBackgroundColor: Colors.white,
          centerBackgroundPadding: 14,
          centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          contentBackgroundColor: Colors.white,
          dialogIcon: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.primaryColor
            ),
            child: SvgPicture.asset('res/drawables/ic_qr_code.svg'),
          ),
          content: ScrollView(
            maxHeight: 400,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text('Scan QR Code',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.textColorBlack)),
                  ),
                  SizedBox(height: 30,),
                  Text(
                    'Scan the QR code on the card package.\nAlternatively, you can enter the card serial\nnumber on the card package',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 16
                    ),
                  ),
                  SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.all(35),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.primaryColor.withOpacity(0.1)
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            left:0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: SvgPicture.asset('res/drawables/ic_card_serial.svg')
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        elevation: 0,
                        onClick: () {
                          Navigator.of(context).pop();
                          _startScanning();
                        },
                        text: 'Start Scan'
                    ),
                  ),
                  SizedBox(height: 24),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (mContext) => _displayCardSerialDialog()
                        );
                      },
                      child: Text(
                          'Enter Serial Number Instead',
                          style: TextStyle(color: Colors.primaryColor, fontSize: 16, fontWeight: FontWeight.normal),
                      )
                  ),
                  SizedBox(height: 36,),
                ],
              ),
            ),
          ),
        ));
  }

  Dialog _displayCardSerialDialog() {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: BottomSheets.makeAppBottomSheet2(
          curveBackgroundColor: Colors.white,
          centerBackgroundPadding: 14,
          centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          contentBackgroundColor: Colors.white,
          dialogIcon: Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.primaryColor
            ),
            child: SvgPicture.asset('res/drawables/ic_qr_code.svg'),
          ),
          content: ScrollView(
            maxHeight: 400,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 27, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Center(
                    child: Text('Scan QR Code',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.textColorBlack)),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Scan the QR code on the card package.\nAlternatively, you can enter the card serial\nnumber on the card package',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 16
                    ),
                  ),
                  SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.all(35),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.primaryColor.withOpacity(0.1)
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            left:0,
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: SvgPicture.asset('res/drawables/ic_card_serial.svg')
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text("Enter Serial Number", textAlign: TextAlign.start,),
                  SizedBox(height: 8),
                  Styles.appEditText(
                      controller: _cardSerialController,
                      hint: 'XXXX-XXXX-XXXX-XXXX',
                      inputType: TextInputType.number,
                      inputFormats: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        _cardSerial = value;
                        _isCardSerialValid = _cardSerial!.length >= 10;
                        if(_isCardSerialValid) FocusManager.instance.primaryFocus?.unfocus();
                      },
                      startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 22),
                      animateHint: true,
                      maxLength: 10
                  ),
                  SizedBox(height: 24,),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.statefulButton2(
                        isValid: true,
                        elevation: 0,
                        onClick: () async {
                          Navigator.of(context).pop();
                          await _qrViewController?.pauseCamera();
                          _startLiveliness();
                        },
                        text: 'Continue'
                    ),
                  ),
                  SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ));
  }

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
  }

  void _showCardActivationCode(String code) async {
    final value = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (mContext) {
          return CardActivationCodeDialog(code);
        }
    );
    if(value is bool && value) {
      Navigator.of(context).pop(true);
    }
  }

  void _startScanning() {
    //A delay is required here to keep the movement between the camera scanner
    //and the liveliness detector minimal
    Future.delayed(Duration(milliseconds: 1000), () {
      _qrCodeStreamSubscription = _qrViewController?.scannedDataStream.listen((scanData) async {
        _qrCodeStreamSubscription?.cancel();
        await _qrViewController?.pauseCamera();
        _result = scanData;
        _startLiveliness();
        // Navigator.of(context).pop(scanData.code);
      });
    });
  }

  void _startLiveliness() async {
    final validationResponse = await Navigator.of(context).pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": LivelinessVerificationFor.CARD_LINKING,
      "cardSerial": _result?.code ?? _cardSerial
    });

    if(validationResponse != null && validationResponse is CardLinkingResponse){
      _showCardActivationCode(validationResponse.issuanceCode ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        child: Scaffold(
          body: Stack(
            children: [
              FutureBuilder(
                  future: _requestCameraPermission(),
                  builder: (mContext, AsyncSnapshot<bool> snapShot) {
                    if(!snapShot.hasData) return Container();
                    if(snapShot.data == false) return Container();
                    return QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    );
                  }
              ),
              Positioned(
                top: 40,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    height: 38,
                    width: 38,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xff21FFFFFF).withOpacity(0.13),
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                        child: SvgPicture.asset(
                          "res/drawables/ic_back.svg", height: 18,
                          width: 18,
                          color: Colors.white,
                        )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    _qrCodeStreamSubscription?.cancel();
    super.dispose();
  }

}