import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_transaction_request.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_detailed_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

import 'card_list_option_item.dart';
import 'dialogs/card_pin_dialog.dart';
import 'dialogs/change_card_pin_dialog.dart';

class CardDetailedView extends StatefulWidget {

  final num cardId;

  CardDetailedView(this.cardId);

  @override
  State<StatefulWidget> createState() => _CardDetailedViewState();

}

class _CardDetailedViewState extends State<CardDetailedView> {

  Card? _card;

  late final _cardOptions = List<Widget>.of([]);
  late SingleCardViewModel _viewModel;

  void _makeCardOptions() {
    _cardOptions.clear();
    _cardOptions.addAll([
      CardListOptionItem(
          onClick: _card!.blocked ? null : () => Navigator.of(context).pushNamed(Routes.MANAGE_CARD_CHANNELS, arguments: {"id": _card?.id}),
          title: "Card Channels",
          subTitle: "Manage ATM, POS & Web Channels",
          leadingIcon: SvgPicture.asset("res/drawables/ic_card_channels.svg")
      ),
      CardListOptionItem(
          onClick: _card!.blocked ? null : null,
          title: "Card Transaction Limit",
          subTitle: "Coming soon",
          leadingIcon: SvgPicture.asset("res/drawables/ic_get_card.svg")
      ),
      CardListOptionItem(
          onClick: _card!.blocked ? null : () => _displayChangePinDialog(_viewModel),
          title: "Change Card PIN",
          subTitle: "Manage ATM, POS & Web Channels",
          leadingIcon: SvgPicture.asset("res/drawables/ic_number_input.svg", color: Colors.primaryColor,)
      ),
    ]);
  }

  @override
  void initState() {
    _viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    super.initState();
  }

  void _displayForBlockOrUnblock(SingleCardViewModel viewModel) async {
    if(_card?.blocked != true /*User wants to block*/) {
      dynamic value = await showInfo(
          context,
          title: "Warning!!!",
          message: "You will have to visit a branch to unblock your card if needed! Proceed to block?",
          onPrimaryClick: () {
            Navigator.of(context).pop(true);
          }
      );

      if(value is bool && value) {
        final transactionRequest = CardTransactionRequest()..cardId = _card?.id;
       _openCardTransactionDialog(viewModel, CardAction.BLOCK_CARD, transactionRequest);
      }
    } else {
      Navigator.of(context).pushNamed(Routes.UNBLOCK_DEBIT_CARD);
    }
  }

  void _displayChangePinDialog(SingleCardViewModel viewModel) async {
    dynamic value = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context:  context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: ChangeCardPinDialog(),
        )
    );

    if (value != null && value is CardTransactionRequest) {
      _openCardTransactionDialog(
          viewModel,
          CardAction.CHANGE_PIN,
          value
            ..cardAccountNumber = _card?.customerAccountCard?.customerAccountNumber ?? ""
            ..cardId = _card?.id
            ..expiry = _card?.expiryDate,
      );
    }
  }

  void _openCardTransactionDialog(SingleCardViewModel viewModel,
      CardAction action, CardTransactionRequest request) async {

    dynamic value = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: CardPinDialog(action, request),
        )
    );
    if(value != null && value is Tuple<String, String>) {
      showSuccess(
          context,
          title: value.first,
          message: value.second,
          onPrimaryClick: () {
            Navigator.of(context).pop();
          }
      );
    } else if(value is Error) {
      showError(context, title: "Card Operation Failed!", message: value.message);
    }
  }

  Widget blockOrUnblockWidget(SingleCardViewModel viewModel) {
    return Column(
      children: [
        Divider(height: 1, thickness: 0.8, color: Color(0XFFE8F0F6).withOpacity(1),),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () => _displayForBlockOrUnblock(viewModel),
            child: Container(
              padding: EdgeInsets.only(
                  left: 20,
                  top: 16,
                  right: 20,
                  bottom: 27
              ),
              child: Row(
                children: [
                  Container(
                    height: 49,
                    width: 49,
                    padding: EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: _card!.blocked
                          ? Colors.solidGreen.withOpacity(0.1)
                          : Colors.darkRed.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                        _card!.blocked
                            ? "res/drawables/ic_card_unlock.svg"
                            : "res/drawables/ic_card_locked_red.svg"
                    ),
                  ),
                  SizedBox(width: 13,),
                  Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _card!.blocked ? "Unblock Card" : "Block Card",
                            style: TextStyle(
                                color: Colors.textColorMainBlack,
                                fontWeight: FontWeight.w600,
                                fontSize: 18
                            ),
                          ),
                          Text(
                              _card!.blocked
                                  ? "Remove usage restrictions on your card"
                                  : "Place usage restrictions on your card"
                          ),
                        ],
                      )
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        child: Scaffold(
          backgroundColor: Color(0XFFEAF4FF),
          appBar: AppBar(
              centerTitle: false,
              titleSpacing: -12,
              iconTheme: IconThemeData(color: Colors.primaryColor),
              title: Text('Card Details',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.darkBlue,
                      fontFamily: Styles.defaultFont,
                      fontSize: 17
                  )
              ),
              backgroundColor: Color(0XFFEAF4FF),
              elevation: 0
          ),
          body: FutureBuilder(
            future: _viewModel.getSingleCard(widget.cardId),
            builder: (mContext, AsyncSnapshot<Card?> snapshot) {
              if(!snapshot.hasData || snapshot.data == null) return Container();
              _card = snapshot.data;
              _makeCardOptions();
              return Stack(
                children: [
                  Positioned(
                      top: 36,
                      left: 16,
                      right: 16,
                      child: CardDetailedItem(_card!)
                  ),
                  Positioned(
                      top: 182,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30)
                            ),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, -10),
                                  blurRadius: 6,
                                  spreadRadius: 0
                              )
                            ]
                        ),
                        child: ListView.separated(
                          itemCount: _cardOptions.length,
                          padding: EdgeInsets.only(bottom: 100),
                          separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(left: 16, right: 16),
                            child: Divider(color: Color(0XFFE8F0F6), height: 1, thickness: 0.5,),
                          ),
                          itemBuilder: (mContext, index) {
                            return _cardOptions[index];
                          },
                        ),
                      )
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: blockOrUnblockWidget(_viewModel)
                  )
                ],
              );
            },
          ),
        ),
    );
  }

}