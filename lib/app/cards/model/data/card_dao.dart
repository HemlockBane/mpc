import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/database/in_memory_cache.dart';
import 'package:collection/collection.dart';

class CardDao extends InMemoryCache<Card> {

  Future<Card?> getCardById(num cardId) async {
    final value = getAllItems();
    var card = value.firstWhereOrNull((element) {
      return element.id == cardId;
    });
    return card;
  }

  Future<Card?> getCardByAccountNumber(String accountNumber) async {
    final cards = getAllItems();
    var card = cards.firstWhereOrNull((element) {
      return element.customerAccountCard?.customerAccountNumber == accountNumber;
    });
    return card;
  }

  int getTotalNumberOfCards() => getAllItems().length;

}