import 'dart:async';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_linking_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_issuance_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_activation_code_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_scan_info_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_serial_dialog.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CardQRCodeScannerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardQRCodeScannerViewState();
}

class _CardQRCodeScannerViewState extends State<CardQRCodeScannerView> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late CardIssuanceViewModel _viewModel;

  QRViewController? _qrViewController;
  StreamSubscription? _qrCodeStreamSubscription;

  initState() {
    _viewModel = Provider.of<CardIssuanceViewModel>(context, listen: false);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _displayScanBarcodeDialog();
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

  void  _displayScanBarcodeDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (mContext) => CardScanInfoDialog(
            context: context,
            onEnterSerial: () {
              Navigator.of(context).pop();
              _displayCardSerialDialog();
            },
            onScanQR: () {
              Navigator.of(context).pop();
              _startScanning();
              _viewModel.updateIssuanceState(CardIssuanceQRCodeState.PROCESSING);
            }
        )
    );
  }

  void _displayCardSerialDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (mContext) => CardSerialDialog(
            context: context,
            viewModel: _viewModel,
            onClick: () async {
              Navigator.of(context).pop();
              await _qrViewController?.pauseCamera();
              _startLiveliness();
            }
        )
    );
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
        _viewModel.updateIssuanceState(CardIssuanceQRCodeState.SUCCESS);
        _qrCodeStreamSubscription?.cancel();
        await _qrViewController?.pauseCamera();
        _viewModel.setCardSerial(scanData.code);

        Future.delayed(Duration(milliseconds: 500), () {
          _startLiveliness();
        });
      });
    });
  }

  void _startLiveliness() async {
    final validationResponse = await Navigator.of(context).pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
      "verificationFor": LivelinessVerificationFor.CARD_LINKING,
      "cardSerial": _viewModel.cardSerial
    });

    if(validationResponse != null && validationResponse is CardLinkingResponse){
      _showCardActivationCode(validationResponse.issuanceCode ?? "");
    }
  }

  Widget _cardIssuanceStateView(BuildContext mContext,
      AsyncSnapshot<CardIssuanceQRCodeState> snapShot){
    if(!snapShot.hasData) return SizedBox(height: 48 * 2);
    if(snapShot.data == CardIssuanceQRCodeState.PROCESSING) {
      return Column(
        children: [
          Lottie.asset('res/drawables/progress_bar_lottie.json', width: 48, height: 48),
          SizedBox(height: 12),
          Text('Processing, Please wait')
        ],
      );
    }
    if(snapShot.data == CardIssuanceQRCodeState.SUCCESS) {
      return Column(
        children: [
          SvgPicture.asset(
              'res/drawables/ic_circular_check_mark.svg',
              width: 48,
              height: 48
          ),
          SizedBox(height: 12),
          Text(
            'Success',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
            ),
          )
        ],
      );
    }
    return Column(children: [Text('Waiting to scan QR')]);
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
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 24, right: 24, top: 32, bottom: 32),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)
                        ),
                        color: Colors.white
                    ),
                    child: StreamBuilder(
                      stream: _viewModel.qrIssuanceState,
                      builder: _cardIssuanceStateView,
                    ),
                  )
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
