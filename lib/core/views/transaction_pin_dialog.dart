import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class TransactionPinDialogState<T extends StatefulWidget> extends State<T> {

  PaymentViewModel getViewModel();
  void subscribeUiToPayment();

  void requestLocationAndSubscribe() {
    subscribeUiToPayment();
    // Permission.location.request().then((value) {
    //   if(value.isGranted) {
    //    // getViewModel().
    //     subscribeUiToPayment();
    //   } else {
    //     subscribeUiToPayment();
    //   }
    // });
  }

}