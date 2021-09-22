import 'dart:ffi';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_request_balance_response.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/service_error.dart';
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
    // return Stream.value(Resource.success([]));
    return _delegate.getCards(customerId).map((event) {
      return event;
    });
  }

  Future<Card?> getSingleCard(num cardId) {
    return _delegate.getCard(cardId);
  }

  Future<Card?> getCardByAccountNumber(String accountNumber) {
    return _delegate.getCardByAccountNumber(accountNumber);
  }

  Stream<Resource<bool>> blockCardChannel(CardTransactionRequest cardRequest) {
    return _delegate.blockCardChannel(customerId, cardRequest);
  }

  Stream<Resource<bool>> unblockCardChannel(CardTransactionRequest cardRequest) {
    return _delegate.unblockCardChannel(customerId, cardRequest);
  }

  Stream<Resource<bool>> blockCard(CardTransactionRequest cardRequest)  {
    return _synchronizeWithCards(_delegate.blockCard(customerId, cardRequest));
  }

  Stream<Resource<bool>> unblockCard(CardTransactionRequest cardRequest) {
    return _delegate.unblockCard(customerId, cardRequest);
  }

  Stream<Resource<bool>> changeCardPin(CardTransactionRequest cardRequest) {
    return _delegate.changeCardPin(customerId, cardRequest);
  }

  Stream<Resource<T>> _synchronizeWithCards<T>(Stream<Resource<T>> actionStream) async* {
    await for (var resource in actionStream) {
      if(resource is Success) yield* _delegate.getCards(customerId).map((event) {
        if(event is Loading) return Resource.loading(resource.data);
        if(event is Success) return Resource.success(resource.data);
        if(event is Error<List<Card>>) return Resource.error(err: ServiceError(message: event.message ?? ""));
        return Resource.success(resource.data);
      });
      if(resource is Loading) yield Resource.loading(null);
      if(resource is Error<T>) yield Resource.error(err: ServiceError(message: resource.message ?? ""));
    }
  }

  Stream<Resource<CardRequestBalanceResponse>> isAccountBalanceSufficient(String? mAccountNumber) {
    return _delegate.isAccountBalanceSufficient(mAccountNumber ?? accountNumber);
  }
}