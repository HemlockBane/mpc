import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/cards/model/card_service_delegate.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';

class SingleCardViewModel extends BaseViewModel {

  late final CardServiceDelegate _delegate;

  Card? _selectedCard;
  Card? get selectedCard => _selectedCard;

  SingleCardViewModel({CardServiceDelegate? delegate}) {
    this._delegate = delegate ?? GetIt.I<CardServiceDelegate>();
  }

  void setSelectedCard(Card card) => this._selectedCard = card;

  Stream<Resource<List<Card>>> getCards() {
    // return Stream.value(Resource.success([
    //   Card(0, "", "", "9999933****342323", "", "23/03", null, null, null, null, "Paul Okeke", null, null, null, null, null, null, null, null, null, null),
    //   Card(0, "", "", "9999933****342323", "", "23/03", null, null, null, null, "AAAAA Okeke", null, null, null, null, null, null, null, null, null, null),
    // ]));
    return _delegate.getCards(customerId).map((event) {
      if(event is Success && event.data?.isNotEmpty == true) {
        _selectedCard = event.data?.first;
      }
      return event;
    });
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
}