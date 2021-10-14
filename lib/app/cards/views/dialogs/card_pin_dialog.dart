
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';

class CardPinDialog extends StatefulWidget {

  final CardAction cardAction;
  final CardTransactionRequest request;

  CardPinDialog(this.cardAction, this.request);

  @override
  State<StatefulWidget> createState() => _CardPinDialog();

}

class _CardPinDialog extends State<CardPinDialog> {

  String _pin = "";
  bool _isLoading = false;
  TextEditingController _reasonController = TextEditingController();

  void beginTransaction(String pin) {
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);

    widget.request
        ..cardId = widget.request.cardId
        ..transactionPin = pin
        ..description = _reasonController.text;

    switch(widget.cardAction) {
      case CardAction.BLOCK_CARD:
        viewModel.blockCard(widget.request).listen(_transactionCallback);
        break;
      case CardAction.UNBLOCK_CARD:
        viewModel.unblockCard(widget.request).listen(_transactionCallback);
        break;
      case CardAction.BLOCK_CARD_CHANNEL:
        viewModel.blockCardChannel(widget.request).listen(_transactionCallback);
        break;
      case CardAction.UNBLOCK_CARD_CHANNEL:
        viewModel.unblockCardChannel(widget.request).listen(_transactionCallback);
        break;
      case CardAction.CHANGE_PIN:
        viewModel.changeCardPin(widget.request).listen(_transactionCallback);
        break;
    }
  }

  Tuple<String, String> getSuccessMessage() {
    switch (widget.cardAction) {
      case CardAction.BLOCK_CARD:
        return Tuple("Card Blocked", "Your card has been blocked successfully.");
      case CardAction.UNBLOCK_CARD:
        return Tuple("Card Unblocked", "Your card has been unblocked successfully.");
      case CardAction.BLOCK_CARD_CHANNEL:
        TransactionChannel? channel = widget.request.transactionChannel;
        String message = "Card blocked for ${(channel != null) ? describeEnum(channel) : ""}";
        return Tuple(message, "Your card has been successfully blocked for ${(channel != null) ? describeEnum(channel) : ""}");
      case CardAction.UNBLOCK_CARD_CHANNEL:
        TransactionChannel? channel = widget.request.transactionChannel;
        String message = "Card unblocked for  ${(channel != null) ? describeEnum(channel) : ""}";
        return Tuple(message, "Your card has been successfully unblocked for ${(channel != null) ? describeEnum(channel) : ""}");
      case CardAction.CHANGE_PIN:
        return Tuple("Card PIN Changed", "Your card PIN has been updated successfully.");
    }
  }

  void _transactionCallback(Resource<bool> event) {
    if(event is Loading) setState(() => _isLoading = true);
    else if(event is Success) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop(getSuccessMessage());
        //Display SuccessDialog
      });
    }
    else if(event is Error<bool>) {
      setState(() {_isLoading = false;});
      Navigator.of(context).pop(event);
    }
  }

  bool _isFormValid()  {
    final isValid = _pin.isNotEmpty && _pin.length >= 4;
    if(widget.cardAction == CardAction.BLOCK_CARD && _reasonController.text.isEmpty) {
      return false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_dialog_three_dots.svg',
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 25,
        content: Wrap(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 22),
                  Center(
                    child: Text('Confirm Action',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.colorPrimaryDark)),
                  ),
                  SizedBox(height: widget.cardAction == CardAction.BLOCK_CARD || widget.cardAction == CardAction.UNBLOCK_CARD ? 12 : 8,),
                  Visibility(
                      visible: widget.cardAction == CardAction.BLOCK_CARD || widget.cardAction == CardAction.UNBLOCK_CARD,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Styles.appEditText(
                            controller: _reasonController,
                            hint: widget.cardAction == CardAction.BLOCK_CARD
                                ? "Why do you want to block this card?"
                                : "why do you want to unblock this card?",
                            animateHint: false
                        ),
                      )
                  ),
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text('Enter Transaction PIN',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.colorPrimaryDark,
                            fontWeight: FontWeight.w600, fontSize: 15)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
                    child: PinEntry(onChange: (value) {
                      setState(() {
                        _pin = value;
                      });
                    }),
                  ),
                  SizedBox(height: 47),
                  Container(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      width: double.infinity,
                      child: Styles.statefulButton2(
                          elevation: _pin.isNotEmpty && _pin.length >= 4 ? 0.5 : 0,
                          isLoading: _isLoading,
                          isValid: _isFormValid(),
                          onClick: () => beginTransaction(_pin),
                          text: 'Continue')),
                  SizedBox(height: 42)
                ],
              ),
            )
          ],
        )
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

}



enum  CardAction {
  BLOCK_CARD, UNBLOCK_CARD, BLOCK_CARD_CHANNEL, UNBLOCK_CARD_CHANNEL, CHANGE_PIN
}