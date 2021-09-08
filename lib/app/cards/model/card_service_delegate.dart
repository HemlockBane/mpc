
import 'dart:io';

import 'package:moniepoint_flutter/app/cards/model/card_service.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/card.dart';
import 'package:collection/collection.dart';

import 'data/card_activation_response.dart';
import 'data/card_link_request.dart';
import 'data/card_linking_response.dart';
import 'data/card_request_balance_response.dart';

class CardServiceDelegate with NetworkResource {

  final CardService _service;

  CardServiceDelegate(this._service);

  //Internal Cards cache/repository
  //Since we can't persist cards in DB
  late final cardA = Card(
      id: 0,
      maskedPan: "514360******4198",
      blocked: false,
      nameOnCard: "Paul Okeke",
      channelBlockStatus: TransactionChannelBlockStatus(web: false, atm: false, pos: false)
  );
  late final List<Card> _cards = [
    cardA,
    Card(id: 1,
        maskedPan: "506099******4323",
        expiryDate: "23/03",
        blocked: false,
        nameOnCard: "AAAAA Okeke",
        isActivated: false,
        channelBlockStatus: TransactionChannelBlockStatus(web: false, atm: false, pos: false)
    ),
    Card(id: 2,
        maskedPan: "506099******4323",
        expiryDate: "23/03",
        blocked: true,
        nameOnCard: "AAAAA Okeke",
        isActivated: true,
        channelBlockStatus: TransactionChannelBlockStatus(web: false, atm: false, pos: false)
    ),
  ];

  Stream<Resource<List<Card>>> getCards(int customerAccountId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.getCards(customerAccountId),
        saveRemoteData: (List<Card> cards) async {
          _cards.clear();
          _cards.addAll(cards);
        }
    );
  }

  Future<Card?> getCard(num cardId) async {
    var card = _cards.firstWhereOrNull((element) {
      return element.id == cardId;
    });
    return card;
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

  Stream<Resource<CardRequestBalanceResponse>> isAccountBalanceSufficient(String accountNumber) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.confirmAccountBalanceIsSufficient(accountNumber)
    );
  }

  Stream<Resource<CardLinkingResponse>> linkCard(CardLinkRequest cardLinkRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.linkCard(
          cardLinkRequest.customerId,
          cardLinkRequest.customerAccountId,
          cardLinkRequest.firstCapture,
          cardLinkRequest.motionCapture,
          customerCode: cardLinkRequest.customerCode,
          cardSerial: cardLinkRequest.cardSerial
        )
    );
  }

  Stream<Resource<CardActivationResponse>> activateCard(CardLinkRequest cardLinkRequest) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.activateCard(
            cardLinkRequest.customerId,
            cardLinkRequest.customerAccountId,
            cardLinkRequest.firstCapture,
            cardLinkRequest.motionCapture,
            cardLinkRequest.customerCode ?? "",
            cardLinkRequest.cardId,
            cardLinkRequest.cvv,
            cardLinkRequest.newPin,
        )
    );
  }

}