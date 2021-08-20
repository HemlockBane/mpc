import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card_request_balance_response.dart';
import 'package:moniepoint_flutter/app/cards/viewmodels/single_card_view_model.dart';
import 'package:moniepoint_flutter/app/cards/views/card_list_option_item.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
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

  late final _emptyCardOptions = List<Widget>.of([
    CardListOptionItem(
        onClick: _checkAccountBalance,
        title: "Get Card Now",
        subTitle: "Look for Agent Locations",
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
    final viewModel = Provider.of<SingleCardViewModel>(context, listen: false);
    viewModel.isAccountBalanceSufficient().listen((event) {
      if(event is Loading) _showLoadingAccountBalance();
      else if (event is Success<CardRequestBalanceResponse>){
        if(event.data?.sufficient == true) {
          Navigator.of(context).pop();
          _getCardDetails();
        } else {
          Navigator.of(context).pop();
          showError(
              context,
              title: "Insufficient Funds",
              message: "Dear Customer,\nYour balance of ${event.data?.availableBalance} is not enough to cover the cost of the card N${event.data?.cardAmount}.\n\nYou can fund your account by depositing at any agent location or transferring from your bank app/USSD",
              useTextButton: true
          );
        }
      }
      else if(event is Error<CardRequestBalanceResponse>){
        Navigator.of(context).pop();
        showError(context, title: "Insufficient Funds", message: event.message);
      }
    });
  }

  void _getCardDetails() async {
    await Future.delayed(Duration(milliseconds: 400), () => true);

    final serialCode = await Navigator.of(context).pushNamed(Routes.CARD_QR_SCANNER);
  }

  void _showLoadingAccountBalance() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (mContext) {
          return BottomSheets.makeAppBottomSheet2(
              curveBackgroundColor: Colors.white,
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              contentBackgroundColor: Colors.white,
              centerBackgroundPadding: 12,
              dialogIcon: SvgPicture.asset(
                'res/drawables/ic_info_italic.svg',
                color: Colors.primaryColor,
                width: 40,
                height: 40,
              ),
              content: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation(Colors.darkBlue)
                              )
                          ),
                        ),
                        SizedBox(height: 8,),
                        Text('Checking account balance... '),
                        SizedBox(height: 18,),
                      ],
                    ),
                  )
                ],
              ));
        }
    );
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

}