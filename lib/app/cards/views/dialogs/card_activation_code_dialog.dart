import 'dart:async';

import 'package:flutter/material.dart' hide Colors, Card;
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

class CardActivationCodeDialog extends StatefulWidget {

  final BuildContext context;
  final String activationCode;
  final Stream<Resource<List<Card>>> Function() cardsStreamFn;
  final int totalNumberOfCards;

  CardActivationCodeDialog({
    required this.context,
    required this.activationCode,
    required this.cardsStreamFn,
    required this.totalNumberOfCards
  });

  @override
  State<StatefulWidget> createState() => _CardActivationCodeDialog();

}

class _CardActivationCodeDialog extends State<CardActivationCodeDialog> {

  StreamSubscription? _streamSubscription;

  _CardActivationCodeDialog();

  bool containsInactiveCard(List<Card>? cards) {
    var containsInActiveCard = false;
    cards?.forEach((element) {
      if(element.isActivated == false) {
        containsInActiveCard = true;
      }
    });
    return containsInActiveCard;
  }

  void _subscribeUiToCardList() {
    if(!mounted) return;

    _streamSubscription = streamWithExponentialBackoff(stream: widget.cardsStreamFn, retries: 5).listen((event) async {
      if(event is Success) {
        final cards = event.data;
        final hasNewCard = (cards?.length ?? 0) > widget.totalNumberOfCards;
        //When a new card is issued,we instantly would have a new card
        //added to the list of the customer cards or in cases where a previous
        //card was replaced(unlinked) then the newly added card should be in an inactive state
        if(hasNewCard || containsInactiveCard(cards)) return Navigator.of(context).pop(event);
        await Future.delayed(Duration(seconds: 5));
        //Recursively
        _streamSubscription?.cancel();
        _subscribeUiToCardList();
      } else if(event is Error<List<Card>>) {
        Navigator.of(context).pop(event);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _subscribeUiToCardList();
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
        context: context,
        sessionTime: 300,//5 minutes
        child: BottomSheets.makeAppBottomSheet2(
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
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      SizedBox(height: 7),
                      Text("Card Activation Code",
                          style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Colors.primaryColor.withOpacity(0.1)),
                        child: Column(
                          children: [
                            Text("Your Moniepoint card issuance code is",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.textColorBlack),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text(widget.activationCode,
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.primaryColor),
                                textAlign: TextAlign.center),
                            SizedBox(height: 10),
                            Text("Show this code to your Moniepoint Agent",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.textColorBlack
                                ),
                                textAlign: TextAlign.center
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 36),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('res/drawables/progress_bar_lottie.json', width: 30, height: 30),
                          SizedBox(width: 8),
                          Text("Awaiting agent confirmation",
                              style: TextStyle(
                                  color: Colors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal
                              )
                          )
                        ],
                      ),
                      SizedBox(height: 36),
                    ],
                  ),
                )
              ],
            ))
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

}