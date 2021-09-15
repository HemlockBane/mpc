import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView, Card;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_linking_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/card_issuance_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_activation_code_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_scan_info_dialog.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/card_serial_dialog.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CardQRCodeScannerView extends StatefulWidget {

  final num customerAccountId;

  CardQRCodeScannerView(this.customerAccountId);

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
      showInfo(
          context,
          title: "Camera Access Disabled",
          message: "Navigate to phone settings to enable camera access",
          primaryButtonText: "Enable Camera Access",
          onPrimaryClick: () {
            AppSettings.openAppSettings();
          }
      );
    }
    return false;
  }

  void  _displayScanBarcodeDialog() async {
    final response = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (mContext) => CardScanInfoDialog(
            context: context,
            onEnterSerial: () {
              Navigator.of(context).pop(true);
              _displayCardSerialDialog();
            },
            onScanQR: () {
              Navigator.of(context).pop(true);
              _startScanning();
              _viewModel.updateIssuanceState(CardIssuanceQRCodeState.PROCESSING);
            }
        )
    );

    if(response == null) {
      Navigator.of(context).pop();
    }
  }

  void _displayCardSerialDialog() async {
    final response = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (mContext) => CardSerialDialog(
            context: context,
            viewModel: _viewModel,
            onClick: () async {
              Navigator.of(context).pop(true);
              await _qrViewController?.pauseCamera();
              _startLiveliness();
            }
        )
    );
    if(response == null) {
      Navigator.of(context).pop();
    }
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
          return CardActivationCodeDialog(
            context: mContext,
            activationCode: code,
            cardsStreamFn: () => _viewModel.getCards(),
            totalNumberOfCards: _viewModel.getTotalNumberOfCards(),
          );
        }
    );

    if(value is Success<List<Card>?>) {
      final cards = value.data;
      if(cards?.isEmpty == true) {
        return showError(
            context,
            title: "Agent Confirmation Failed",
            message: "Failed to retrieve agent confirmation at this time, please try again later.",
            primaryButtonText: "Go Back to Cards"
        );
      }
      final card = cards!.first;
      Navigator.of(context).popAndPushNamed(Routes.CARD_ACTIVATION, arguments: {"id": card.id}).then((value) {
        print("What's the value after activation ==>>> ");
      });
    } else if (value is Error<List<Card>>) {
      showError(
          context,
          title: "Agent Confirmation Failed",
          message: "Failed to retrieve agent confirmation at this time, please try again later."
      );
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.CARDS, ModalRoute.withName(Routes.DASHBOARD)
      );
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
      "cardSerial": _viewModel.cardSerial,
      "customerAccountId": widget.customerAccountId
    });

    if(validationResponse != null && validationResponse is CardLinkingResponse){
      _showCardActivationCode(validationResponse.issuanceCode ?? "");
    }

    if(validationResponse == null) Navigator.of(context).pop();
  }

  Widget _cardIssuanceStateView(BuildContext mContext,
      AsyncSnapshot<CardIssuanceQRCodeState> snapShot){
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerBackgroundPadding: 14,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        dialogIcon: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.primaryColor),
          child: SvgPicture.asset('res/drawables/ic_qr_code.svg'),
        ),
        content: Wrap(
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50,),
                  Center(child: Text(
                    "Scan QR code on card package",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.textColorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),),
                  SizedBox(height: 100,),
                ],
              ),
            )
          ],
        ));
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
                  child: StreamBuilder(
                    stream: _viewModel.qrIssuanceState,
                    builder: _cardIssuanceStateView,
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
