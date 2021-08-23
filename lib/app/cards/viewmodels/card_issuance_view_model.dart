import 'dart:async';

import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
enum CardIssuanceQRCodeState {
  STARTED, PROCESSING, SUCCESS, IDLE
}
class CardIssuanceViewModel extends BaseViewModel {

  String? _cardSerial;
  String? get cardSerial => _cardSerial;

  StreamController<bool> _cardSerialValidityController = StreamController.broadcast();
  Stream<bool> get isCardSerialValidStream => _cardSerialValidityController.stream;

  StreamController<CardIssuanceQRCodeState> _qrIssuanceStateController = StreamController.broadcast();
  Stream<CardIssuanceQRCodeState> get qrIssuanceState => _qrIssuanceStateController.stream;

  void setCardSerial(String cardSerialNumber) {
    this._cardSerial = cardSerialNumber;
  }

  void updateIssuanceState(CardIssuanceQRCodeState state) {
    _qrIssuanceStateController.sink.add(state);
  }

  void onCardSerialChange(String? cardSerial){
    if(isCardSerialValid(cardSerial)) {
      _cardSerialValidityController.sink.add(true);
    } else {
      _cardSerialValidityController.sink.add(false);
    }
  }

  bool isCardSerialValid(String? cardSerial) {
    if(cardSerial == null) return false;
    if(cardSerial.length < 10) return false;
    return true;
  }

  @override
  void dispose() {
    _cardSerialValidityController.close();
    _qrIssuanceStateController.close();
    super.dispose();
  }
}