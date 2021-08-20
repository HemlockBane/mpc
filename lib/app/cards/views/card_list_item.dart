import 'dart:ui';

import 'package:flutter/material.dart' hide Card, Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/cards/model/data/card.dart';
import 'package:moniepoint_flutter/app/cards/views/utils/card_view_util.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class CardListItem extends Container {

  final Card card;
  final int position;
  final OnItemClickListener<Card, int> onItemClickListener;

  CardListItem(this.card, this.position, this.onItemClickListener);

  final cardNumberStyle = TextStyle(
      letterSpacing: 1.2,
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: Styles.ocraExtended
  );

  Widget _cardName() {
    final cardNameWidget = Text(
      card.nameOnCard ?? "",
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
    );
    if(card.status == CardStatus.IN_ACTIVE) {
      return Expanded(child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: cardNameWidget,
      ));
    }

    return Expanded(child: cardNameWidget);
  }

  Widget _cardNumberAndLogo() {
    final cardNumberWidget = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(CardViewUtil.getFirst6Digits(card), style: cardNumberStyle,),
            Text(' ** **** ', style: TextStyle(
              letterSpacing: 1.2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: Styles.ocraExtended
            )),
            Text(CardViewUtil.getLast4Digits(card), style: cardNumberStyle,),
          ],
        ),
        CardViewUtil.getCardBrandLogo(card)
      ],
    );
    if(card.status == CardStatus.IN_ACTIVE) {
      return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
          child: cardNumberWidget,
      );
    }
    return cardNumberWidget;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: CardViewUtil.getCardBackground(card),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            color: (!card.blocked) ? Colors.primaryColor.withOpacity(0.48) : Colors.red.withOpacity(0.5),
            spreadRadius: 0,//0.1,
            blurRadius: 0//12
          )
        ]
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(24)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          onTap: () => Navigator.of(context).pushNamed(Routes.CARD_DETAIL, arguments: Map.from({"id":card.id})),
          child: Container(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: card.blocked ? 14 : 16,
                bottom: 16
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _cardName(),
                    SizedBox(width: 4),
                    CardViewUtil.getCardStateBanner(card)
                  ],
                ),
                SizedBox(height: card.blocked ? 12 : 16,),
                _cardNumberAndLogo(),
                // SizedBox(height: (card.status == CardStatus.IN_ACTIVE) ? 16 : 0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}