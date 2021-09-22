
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';

import 'data/card.dart';

import 'data/card_activation_response.dart';
import 'data/card_dao.dart';
import 'data/card_link_request.dart';
import 'data/card_linking_response.dart';
import 'data/card_otp_linking_response.dart';
import 'data/card_otp_validation_response.dart';
import 'data/card_request_balance_response.dart';

class CardServiceDelegate with NetworkResource {

  final CardService _service;
  final CardDao _cardCache;

  CardServiceDelegate(this._service, this._cardCache);

  Stream<Resource<List<Card>>> getCards(int customerId) {
    return networkBoundResource(
        shouldFetchLocal: true,
        fetchFromLocal: () => _cardCache.getItems(),
        fetchFromRemote: () => _service.getCards(customerId),
        saveRemoteData: (List<Card> cards) async {
          _cardCache.deleteAll();
          _cardCache.addAll(cards);
        }
    );
  }

  Future<Card?> getCard(num cardId) async {
    return _cardCache.getCardById(cardId);
  }

  Future<Card?> getCardByAccountNumber(String accountNumber) async {
    return _cardCache.getCardByAccountNumber(accountNumber);
  }

  int getNumberOfCards() {
    return _cardCache.getTotalNumberOfCards();
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

  Stream<Resource<CardOtpLinkingResponse>> sendCardLinkingOtp(num customerAccountId) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.sendCardLinkingOtp("$customerAccountId")
    );
  }

  Stream<Resource<CardOtpValidationResponse>> validateCardLinkingOtp(
      num customerAccountId, String otp, String userCode) {
    return networkBoundResource(
        fetchFromLocal: () => Stream.value(null),
        fetchFromRemote: () => _service.validateCardLinkingOtp("$customerAccountId", {
          "otp": otp,
          "userCode" : userCode
        })
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
          cardLinkRequest.otpValidationKey,
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