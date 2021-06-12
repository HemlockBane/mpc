
import 'package:moniepoint_flutter/app/cards/model/card_service.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/card.dart';

class CardServiceDelegate with NetworkResource {

  final CardService _service;

  CardServiceDelegate(this._service);


  Stream<Resource<List<Card>>> getCards(int customerAccountId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.getCards(customerAccountId)
    );
  }

  Stream<Resource<bool>> blockCard(int customerAccountId, CardTransactionRequest cardTransactionRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.blockCard(customerAccountId, cardTransactionRequest)
    );
  }

  Stream<Resource<bool>> unblockCard(int customerAccountId, CardTransactionRequest cardTransactionRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.unblockCard(customerAccountId, cardTransactionRequest)
    );
  }

  Stream<Resource<bool>> blockCardChannel(int customerAccountId, CardTransactionRequest cardTransactionRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.blockCardChannel(customerAccountId, cardTransactionRequest)
    );
  }

  Stream<Resource<bool>> unblockCardChannel(int customerAccountId, CardTransactionRequest cardTransactionRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.unblockCardChannel(customerAccountId, cardTransactionRequest)
    );
  }

  Stream<Resource<bool>> changeCardPin(int customerAccountId, CardTransactionRequest cardTransactionRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.changeCardPin(customerAccountId, cardTransactionRequest)
    );
  }

}