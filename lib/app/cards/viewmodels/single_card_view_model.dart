import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_request_balance_response.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class SingleCardViewModel extends BaseViewModel {

  late final CardServiceDelegate _delegate;

  SingleCardViewModel({CardServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<CardServiceDelegate>();
  }

  Stream<Resource<List<Card>>> getCards() {
    // return Stream.value(Resource.success([
    //   Card(id: 30,maskedPan: "514360******4198", expiryDate: "23/03", blocked: false, nameOnCard: "AAAAA Okeke", isActivated: true),
    //   Card(id: 31,maskedPan: "506099******4323", expiryDate: "23/03", blocked: false, nameOnCard: "AAAAA Okeke", isActivated: false),
    //   Card(id: 32,maskedPan: "406099******4323", expiryDate: "23/03", blocked: true, nameOnCard: "Ebun Oluwa", isActivated: true),
    // ]));
    return _delegate.getCards(customerId).map((event) {
      return event;
    });
  }

  Future<Card?> getSingleCard(num cardId) {
    return _delegate.getCard(cardId);
  }

  Stream<Resource<bool>> blockCardChannel(CardTransactionRequest cardRequest) {
    return _delegate.blockCardChannel(customerId, cardRequest);
  }

  Stream<Resource<bool>> unblockCardChannel(CardTransactionRequest cardRequest) {
    return _delegate.unblockCardChannel(customerId, cardRequest);
  }

  Stream<Resource<bool>> blockCard(CardTransactionRequest cardRequest) {
    return _delegate.blockCard(customerId, cardRequest);
  }

  Stream<Resource<bool>> unblockCard(CardTransactionRequest cardRequest) {
    return _delegate.unblockCard(customerId, cardRequest);
  }

  Stream<Resource<bool>> changeCardPin(CardTransactionRequest cardRequest) {
    return _delegate.changeCardPin(customerId, cardRequest);
  }

  Stream<Resource<CardRequestBalanceResponse>> isAccountBalanceSufficient() {
    return _delegate.isAccountBalanceSufficient(accountNumber);
  }
}