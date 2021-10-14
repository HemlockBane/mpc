import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_otp_linking_response.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_otp_validation_response.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
enum CardIssuanceQRCodeState {
  STARTED, PROCESSING, SUCCESS, IDLE
}
class CardIssuanceViewModel extends BaseViewModel {
  late final CardServiceDelegate _delegate;

  String? _cardSerial;
  String? get cardSerial => _cardSerial;

  num? _cardCustomerAccountId;
  num? get cardCustomerAccountId => _cardCustomerAccountId;

  String? _userCode;
  String? get userCode => _userCode;

  StreamController<bool> _cardSerialValidityController = StreamController.broadcast();
  Stream<bool> get isCardSerialValidStream => _cardSerialValidityController.stream;

  StreamController<CardIssuanceQRCodeState> _qrIssuanceStateController = StreamController.broadcast();
  Stream<CardIssuanceQRCodeState> get qrIssuanceState => _qrIssuanceStateController.stream;

  CardIssuanceViewModel({CardServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<CardServiceDelegate>();
  }

  Stream<Resource<List<Card>>> getCards() {
    return _delegate.getCards(customerId).map((event) {
      return event;
    });
  }

  Stream<Resource<CardOtpLinkingResponse>> sendCardLinkingOtp(num customerAccountId) {
    return _delegate.sendCardLinkingOtp(customerAccountId);
  }

  Stream<Resource<CardOtpValidationResponse>> validateCardLinkingOtp(
      num customerAccountId, String otp) {
    return _delegate.validateCardLinkingOtp(customerAccountId, otp, userCode ?? "");
  }

  int getTotalNumberOfCards() => _delegate.getNumberOfCards();

  void setCardSerial(String cardSerialNumber) {
    this._cardSerial = cardSerialNumber;
  }

  void setCardCustomerAccountId(num cardCustomerAccountId) {
    this._cardCustomerAccountId = cardCustomerAccountId;
  }

  void setUserCode(String userCode) {
    this._userCode = userCode;
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