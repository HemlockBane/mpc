import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class TransactionPinDialogState<T extends StatefulWidget> extends State<T> {

  PaymentViewModel getViewModel();
  void subscribeUiToPayment();

  void requestLocationAndSubscribe() async {
    final isGranted = await Permission.location.request().isGranted;
    if (isGranted) {
      try {
        Position? lastLocation = await Geolocator.getLastKnownPosition();
        print("Requesting location");
        if (lastLocation == null)
          lastLocation = await Geolocator.getCurrentPosition();
        print("Last location $lastLocation");
        getViewModel().setLocation(lastLocation);
        subscribeUiToPayment();
      } catch (e) {
        print(e);
        subscribeUiToPayment();
      }
    } else {
      subscribeUiToPayment();
    }
  }

}