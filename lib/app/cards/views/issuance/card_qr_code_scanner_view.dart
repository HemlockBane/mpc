import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CardQRCodeScannerView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CardQRCodeScannerViewState();
}

class _CardQRCodeScannerViewState extends State<CardQRCodeScannerView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? _qrViewController;

  void _onQRViewCreated(QRViewController controller) {
    this._qrViewController = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

}