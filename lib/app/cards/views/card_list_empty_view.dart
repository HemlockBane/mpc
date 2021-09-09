import 'dart:async';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_request_balance_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_option_item.dart';
import 'package:moniepoint_flutter/app/cards/views/dialogs/insufficient_funds_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';

class CardListEmptyView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _CardListEmptyViewState();

}

class _CardListEmptyViewState extends State<CardListEmptyView> {

  late final SingleCardViewModel _viewModel;

  final StreamController<Resource<CardRequestBalanceResponse>> _getCardController = StreamController.broadcast();
  Stream<Resource<CardRequestBalanceResponse>> get _processingProxy => _getCardController.stream;

  late final _emptyCardOptions = List<Widget>.of([
    CardListOptionItem(
        onClick: _checkAccountBalance,
        title: "Get Card Now",
        subTitle: "From Agent Location",
        processStream: _processingProxy,
        leadingIcon: SvgPicture.asset("res/drawables/ic_get_card.svg")
    ),
    CardListOptionItem(
        onClick: null,
        title: "Card Delivery",
        subTitle: "Coming Soon",
        leadingIcon: SvgPicture.asset("res/drawables/ic_card_delivery.svg")
    ),
    CardListOptionItem(
        onClick: null,
        title: "Virtual Card",
        subTitle: "Coming Soon",
        leadingIcon: SvgPicture.asset("res/drawables/ic_virtual_card_web.svg")
    ),
  ]);

  void _checkAccountBalance() {
    _viewModel.isAccountBalanceSufficient().listen((event) {
      _getCardController.sink.add(event);
      if (event is Success<CardRequestBalanceResponse>){
        if(event.data?.sufficient == true) {
          _getCardDetails();
        } else {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              context: context,
              builder: (ctx) {
                return InsufficientFundsDialog(
                    accountBalance: event.data?.availableBalance ?? "0.0",
                    cardCost: event.data?.cardAmount ?? ""
                );
              }
          );
        }
      }
      else if(event is Error<CardRequestBalanceResponse>){
        showError(context, title: "Insufficient Funds", message: event.message);
      }
    });
  }

  void _getCardDetails() async {
    await Future.delayed(Duration(milliseconds: 400), () => true);
    final serialCode = await Navigator.of(context).pushNamed(Routes.CARD_QR_SCANNER);
  }

  @override
  void initState() {
    _viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            left: 16,
            right: 16,
            child: Container(
              height: 160,
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.primaryColor.withOpacity(0.1)
              ),
              child: Column(
                children: [
                  SvgPicture.asset('res/drawables/ic_add_card.svg'),
                  SizedBox(height: 0,),
                  Text(
                    'Request for a new debit card\nor virtual card',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.solidDarkBlue,
                      fontSize: 15
                    ),
                  )
                ],
              ),
            )
        ),
        Positioned(
            top: 125,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.primaryColor.withOpacity(0.05),
                        offset: Offset(0, -10),
                        blurRadius: 6,
                        spreadRadius: 0
                    )
                  ]
              ),
              child: ListView.separated(
                itemCount: _emptyCardOptions.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(color: Color(0XFFE8F0F6), height: 1, thickness: 0.5,),
                ),
                itemBuilder: (mContext, index) {
                  return _emptyCardOptions[index];
                },
              ),
            )
        )
      ],
    );
  }

  @override
  void dispose() {
    _getCardController.close();
    super.dispose();
  }

}