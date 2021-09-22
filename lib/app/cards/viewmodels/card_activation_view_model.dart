import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class CardActivationViewModel extends BaseViewModel {
  late final CardServiceDelegate _delegate;

  String? _newPin;
  String? get newPin => _newPin;

  String? _cvv;
  String? get cvv => _cvv;

  final StreamController<Tuple<int, bool>> _pageFormController = StreamController.broadcast();
  Stream<Tuple<int, bool>> get pageFormStream => _pageFormController.stream;

  CardActivationViewModel({CardServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<CardServiceDelegate>();
  }

  void refreshCards() {
    StreamSubscription? subscription;
    subscription = this._delegate.getCards(customerId).listen((event) {
      if(event is Success || event is Error) subscription?.cancel();
    });
  }

  Future<Card?> getSingleCard(num cardId) {
    return _delegate.getCard(cardId);
  }

  void setNewPin(String newPin){
    this._newPin = newPin;
  }

  void setCVV(String cvv) {
    this._cvv = cvv;
  }

  /// if next is false then we are moving the page to the previous
  void movePage(int pageIndex, {bool next = true}) {
    _pageFormController.sink.add(Tuple(pageIndex, next));
  }

  @override
  void dispose() {
    _pageFormController.close();
    super.dispose();
  }

}