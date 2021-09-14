import 'dart:ui';

import 'package:flutter/material.dart' hide Card, Colors;
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
                top: card.blocked ? 20 : 22,
                bottom: 22
            ),
            child: Column(
              children: [
                _CardTopView(card: card,),
                SizedBox(height: card.blocked ? 12 : 16,),
                _CardNumberAndLogoView(card: card,),
                SizedBox(height: (!card.isActivated) ? 16 : 0,),
                _CardActivateButton(card: card,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


///_CardTopView
///
///
///
///
class _CardTopView extends StatelessWidget {

  final Card card;

  _CardTopView({required this.card}):super(key: Key("card-top"));

  Widget _cardName() {
    final cardNameWidget = Text(
      card.nameOnCard ?? "",
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
    );
    if(!card.isActivated) {
      return Expanded(child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: cardNameWidget,
      ));
    }

    return Expanded(child: cardNameWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _cardName(),
        SizedBox(width: 4),
        CardViewUtil.getCardStateBanner(card)
      ],
    );
  }

}

///_CardNumberAndLogoView
///
///
///
///
///
class _CardNumberAndLogoView extends StatelessWidget {

  final Card card;

  final cardNumberStyle = TextStyle(
      letterSpacing: 0.4,
      fontSize: 19.5,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      fontFamily: Styles.ocraExtended
  );

  _CardNumberAndLogoView({required this.card});

  @override
  Widget build(BuildContext context) {
    final cardNumberWidget = LayoutBuilder(builder: (ctx, constraint) {

      final asterisk = (constraint.maxWidth <= 300) ? " * ** " : " ** **** ";
      final letterSpacing = (constraint.maxWidth <= 300) ? 0.1 : 1.2;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(CardViewUtil.getFirst6Digits(card),
                  style: cardNumberStyle.copyWith(letterSpacing: letterSpacing)
              ),
              Text(asterisk, style: TextStyle(
                  letterSpacing: letterSpacing, //TODO factor in screen width
                  fontSize: 19.5,
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
    });
    if(!card.isActivated) {
      return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
        child: cardNumberWidget,
      );
    }
    return cardNumberWidget;
  }

}

///_CardActivateButton
///
///
///
///
///
class _CardActivateButton extends StatelessWidget {

  final Card card;

  _CardActivateButton({required this.card}):super(key: Key("_card_activation"));

  @override
  Widget build(BuildContext context) {
    if(card.isActivated) return SizedBox();
    return SizedBox(
      width: double.infinity,
      child: Styles.appButton(
          elevation: 0.1,
          onClick: ()  {
            Navigator.of(context).pushNamed(Routes.CARD_ACTIVATION, arguments: {"id": card.id});
          },
          text: "Activate Card",
          buttonStyle: Styles.whiteButtonStyle.copyWith(
              padding: MaterialStateProperty.all(EdgeInsets.only(left:0, right:20, top: 0, bottom: 0)),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              backgroundColor: MaterialStateProperty.all(Colors.white.withOpacity(0.45)),
              overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2))
          )
      ),
    );
  }

}